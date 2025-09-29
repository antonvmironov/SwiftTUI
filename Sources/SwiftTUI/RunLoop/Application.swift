
import Foundation
#if os(macOS)
import AppKit
#endif

import _Concurrency

@MainActor
public class Application {
    private let node: Node
    private let window: Window
    private let control: Control
    private let renderer: Renderer

    private var arrowKeyParser = ArrowKeyParser()

    private var invalidatedNodes: [Node] = []
    private var updateScheduled = false


    public init<I: View>(rootView: I) {
        node = Node(view: VStack(content: rootView).view)
        node.build()

        control = node.control!

        window = Window()
        window.addControl(control)

        window.firstResponder = control.firstSelectableElement
        window.firstResponder?.becomeFirstResponder()

        renderer = Renderer(layer: window.layer)
        window.layer.renderer = renderer

        node.application = self
        renderer.application = self
    }

    var stdInSource: DispatchSourceRead?

    @MainActor
    public func start() async {
        setInputMode()
        updateWindowSize()
        control.layout(size: window.layer.frame.size)
        renderer.draw()

        do {
            try await withThrowingTaskGroup { group in
                group.addTask {
                    try await self.inputLoop()
                }
                group.addTask {
                    await self.signalLoop(signal: SIGWINCH) { [weak self] in await self?.handleWindowSizeChange() }
                }
                group.addTask {
                    await self.signalLoop(signal: SIGINT) { [weak self] in await self?.stopAndExit() }
                }
                try await group.next()
                group.cancelAll()
            }
        } catch {
            // TODO: cleanup if needed
        }
    }

    // Async input loop using FileHandle
    private func inputLoop() async throws {
        let fileHandle = FileHandle.standardInput
        while true {
            let data = fileHandle.availableData
            if !data.isEmpty, let string = String(data: data, encoding: .utf8) {
                for char in string {
                    await handleInputChar(char)
                }
            }
            try await ContinuousClock().sleep(for: .milliseconds(10)) // 10ms to avoid busy loop
        }
    }

    // Async signal handler using Task
    private func signalLoop(signal: Int32, handler: @escaping @Sendable () async -> Void) async {
        let signalSource = SignalSource(signal: signal)
        for await _ in signalSource.stream {
            await handler()
        }
    }

    // Helper for async signal handling

    @MainActor
    private class SignalSource {
        let stream: AsyncStream<Void>
        private let continuation: AsyncStream<Void>.Continuation
        private var signal: Int32

        init(signal: Int32) {
            self.signal = signal
            (self.stream, self.continuation) = AsyncStream.makeStream(of: Void.self)
            SignalHandlerRegistry.shared.register(signal: signal) { [weak self] in self?.continuation.yield(()) }
        }

        isolated deinit {
            SignalHandlerRegistry.shared.unregister(signal: signal)
        }
    }

    // Global signal handler registry (not actor-isolated)
    @MainActor
    private class SignalHandlerRegistry {
        static let shared = SignalHandlerRegistry()
        private var handlers: [Int32: () -> Void] = [:]
        private let queue = DispatchQueue(label: "SignalHandlerRegistry")

        private init() {}

        func register(signal: Int32, handler: @escaping () -> Void) {
            queue.sync {
                handlers[signal] = handler
            }
            _ = Darwin.signal(signal, SignalHandlerRegistry.signalHandler)
        }

        func unregister(signal: Int32) {
            queue.sync {
                handlers[signal] = nil
            }
        }

        private static let signalHandler: @convention(c) (Int32) -> Void = { sig in
            SignalHandlerRegistry.shared.queue.sync {
                SignalHandlerRegistry.shared.handlers[sig]?()
            }
        }
    }

    // Handle a single input character
    @MainActor
    private func handleInputChar(_ char: Character) async {
        if arrowKeyParser.parse(character: char) {
            guard let key = arrowKeyParser.arrowKey else { return }
            arrowKeyParser.arrowKey = nil
            if key == .down {
                if let next = window.firstResponder?.selectableElement(below: 0) {
                    window.firstResponder?.resignFirstResponder()
                    window.firstResponder = next
                    window.firstResponder?.becomeFirstResponder()
                }
            } else if key == .up {
                if let next = window.firstResponder?.selectableElement(above: 0) {
                    window.firstResponder?.resignFirstResponder()
                    window.firstResponder = next
                    window.firstResponder?.becomeFirstResponder()
                }
            } else if key == .right {
                if let next = window.firstResponder?.selectableElement(rightOf: 0) {
                    window.firstResponder?.resignFirstResponder()
                    window.firstResponder = next
                    window.firstResponder?.becomeFirstResponder()
                }
            } else if key == .left {
                if let next = window.firstResponder?.selectableElement(leftOf: 0) {
                    window.firstResponder?.resignFirstResponder()
                    window.firstResponder = next
                    window.firstResponder?.becomeFirstResponder()
                }
            }
        } else if char == ASCII.EOT {
            await stopAndExit()
        } else {
            window.firstResponder?.handleEvent(char)
        }
    }

    // Stop and exit gracefully
    @MainActor
    private func stopAndExit() async {
        renderer.stop()
        resetInputMode()
        exit(0)
    }

    private func setInputMode() {
        var tattr = termios()
        tcgetattr(STDIN_FILENO, &tattr)
        tattr.c_lflag &= ~tcflag_t(ECHO | ICANON)
        tcsetattr(STDIN_FILENO, TCSAFLUSH, &tattr)
    }

    // ...existing code...

    func invalidateNode(_ node: Node) {
        invalidatedNodes.append(node)
        scheduleUpdate()
    }

    /// Updates the focus to match the given focus value
    func updateFocus<Value>(to focusValue: Value?) where Value: Hashable & Sendable {
        // This method updates the actual focus in the terminal UI
        // For now, we'll implement basic focus updating by finding controls with matching focus values
        // In a more sophisticated implementation, this could maintain a focus registry

        guard let focusValue = focusValue else {
            // Clear focus - let the current first responder handle this naturally
            return
        }

        // Find and focus the control with the matching focus value
        // This is a basic implementation - a production version might use a focus registry
        findAndFocusControl(in: control, for: focusValue)
    }

    private func findAndFocusControl<Value>(in control: Control, for focusValue: Value) where Value: Hashable & Sendable {
        // Check if this is a focusable control with matching value
        if let focusableControl = control as? FocusableControl<Value>,
           focusableControl.focusValue == focusValue {
            window.firstResponder?.resignFirstResponder()
            window.firstResponder = focusableControl
            focusableControl.becomeFirstResponder()
            return
        }

        // Recursively search children
        for child in control.children {
            findAndFocusControl(in: child, for: focusValue)
        }
    }

    func scheduleUpdate() {
        if !updateScheduled {
            Task { @MainActor in self.update() }
            updateScheduled = true
        }
    }

    private func update() {
        updateScheduled = false

        for node in invalidatedNodes {
            node.update(using: node.view)
        }
        invalidatedNodes = []

        control.layout(size: window.layer.frame.size)
        renderer.update()
    }

    private func handleWindowSizeChange() {
        updateWindowSize()
        control.layer.invalidate()
        update()
    }

    private func updateWindowSize() {
        var size = winsize()
        guard ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &size) == 0,
              size.ws_col > 0, size.ws_row > 0 else {
            assertionFailure("Could not get window size")
            return
        }
        window.layer.frame.size = Size(width: Extended(Int(size.ws_col)), height: Extended(Int(size.ws_row)))
        renderer.setCache()
    }

    // ...existing code...

    /// Fix for: https://github.com/rensbreur/SwiftTUI/issues/25
    private func resetInputMode() {
        // Reset ECHO and ICANON values:
        var tattr = termios()
        tcgetattr(STDIN_FILENO, &tattr)
        tattr.c_lflag |= tcflag_t(ECHO | ICANON)
        tcsetattr(STDIN_FILENO, TCSAFLUSH, &tattr);
    }

    /// Updates the bool focus state
    func updateBoolFocus(focused: Bool) {
        // For Bool focus, we either focus a specific control or clear focus
        if focused {
            // Try to find a focusable control that should be focused
            // For now, we'll just ensure there's a first responder
            if window.firstResponder == nil {
                window.firstResponder = control.firstSelectableElement
                window.firstResponder?.becomeFirstResponder()
            }
        } else {
            // Clear focus by resigning first responder
            window.firstResponder?.resignFirstResponder()
            window.firstResponder = nil
        }
    }

}
