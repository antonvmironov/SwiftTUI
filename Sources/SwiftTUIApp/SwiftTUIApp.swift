import ArgumentParser
import SwiftTUI

@main
struct SwiftTUIApp: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "app",
        abstract: "App command-line interface",
    )

    @MainActor
    mutating func run() async throws {
        var runTask: Task<Void, Error>!
        let contentView = contentView {
            runTask?.cancel()
        }
        runTask = Task { @MainActor in
            await Application(rootView: contentView).start()
        }
        try await runTask.value
    }

    @MainActor
    func contentView(exit: @escaping @MainActor () -> Void) -> some View {
        VStack {
            Text("Hello world!")
            Button("I'm done here!") {
                exit()
            }
        }
    }
}
