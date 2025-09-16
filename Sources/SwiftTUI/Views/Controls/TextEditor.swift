import Foundation

/// A multiline text editor component for terminal environments
/// Similar to SwiftUI's TextEditor but optimized for terminal display
public struct TextEditor: View {
    @Binding private var text: String
    private let placeholder: String
    @State private var lines: [String] = []
    @State private var currentLine: Int = 0
    @State private var cursorPosition: Int = 0
    @State private var isEditing: Bool = false
    
    /// Creates a text editor with a binding to the text
    public init(text: Binding<String>) {
        self._text = text
        self.placeholder = "Enter text..."
    }
    
    /// Creates a text editor with a placeholder
    public init(_ placeholder: String = "Enter text...", text: Binding<String>) {
        self._text = text
        self.placeholder = placeholder
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Editor header
            HStack {
                Text(isEditing ? "Editing" : "Text Editor")
                    .foregroundColor(isEditing ? Color.blue : Color.gray)
                Spacer()
                Text("Lines: \(lines.count)")
                    .foregroundColor(Color.gray)
            }
            .padding(.horizontal)
            .padding(.bottom, 1)
            
            // Text content area
            VStack(alignment: .leading, spacing: 0) {
                if lines.isEmpty && text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color.gray)
                        .italic()
                        .padding(.all, 1)
                } else {
                    ForEach(Array(lines.enumerated()), id: \.offset) { index, line in
                        HStack {
                            Text("\(index + 1)")
                                .foregroundColor(Color.gray)
                                .frame(width: 3)
                            
                            if index == currentLine && isEditing {
                                Text(line + "|")
                                    .foregroundColor(Color.white)
                            } else {
                                Text(line.isEmpty ? " " : line)
                                    .foregroundColor(Color.white)
                            }
                            
                            Spacer()
                        }
                        .background(index == currentLine && isEditing ? Color.blue.opacity(0.2) : Color.clear)
                    }
                    
                    // Empty line indicator when editing
                    if isEditing && currentLine >= lines.count {
                        HStack {
                            Text("\(lines.count + 1)")
                                .foregroundColor(Color.gray)
                                .frame(width: 3)
                            Text("|")
                                .foregroundColor(Color.white)
                            Spacer()
                        }
                        .background(Color.blue.opacity(0.2))
                    }
                }
            }
            .border()
            .frame(minHeight: 8)
            
            // Status bar
            HStack {
                if isEditing {
                    Text("ESC: Exit | ENTER: New Line | ↑↓: Navigate")
                        .foregroundColor(Color.gray)
                } else {
                    Text("ENTER: Edit | Lines: \(lines.count), Characters: \(text.count)")
                        .foregroundColor(Color.gray)
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .onAppear {
            updateLines()
        }
    }
    
    private func updateLines() {
        if text.isEmpty {
            lines = []
        } else {
            lines = text.components(separatedBy: .newlines)
        }
    }
    
    private func updateText() {
        text = lines.joined(separator: "\n")
    }
    
    private func enterEditMode() {
        isEditing = true
        if lines.isEmpty {
            lines = [""]
        }
        currentLine = min(currentLine, lines.count - 1)
    }
    
    private func exitEditMode() {
        isEditing = false
        updateText()
    }
    
    private func insertNewLine() {
        if currentLine < lines.count {
            let currentText = lines[currentLine]
            let beforeCursor = String(currentText.prefix(cursorPosition))
            let afterCursor = String(currentText.dropFirst(cursorPosition))
            
            lines[currentLine] = beforeCursor
            lines.insert(afterCursor, at: currentLine + 1)
        } else {
            lines.append("")
        }
        
        currentLine += 1
        cursorPosition = 0
    }
    
    private func navigateUp() {
        if currentLine > 0 {
            currentLine -= 1
            cursorPosition = min(cursorPosition, lines[currentLine].count)
        }
    }
    
    private func navigateDown() {
        if currentLine < lines.count - 1 {
            currentLine += 1
            cursorPosition = min(cursorPosition, lines[currentLine].count)
        }
    }
}

/// Enhanced TextEditor with word wrapping support
extension TextEditor {
    /// Creates a text editor with automatic word wrapping
    public static func wrapped(
        _ placeholder: String = "Enter text...",
        text: Binding<String>,
        lineWidth: Int = 60
    ) -> WrappedTextEditor {
        WrappedTextEditor(placeholder: placeholder, text: text, lineWidth: lineWidth)
    }
}

/// A text editor with automatic word wrapping
public struct WrappedTextEditor: View {
    @Binding private var text: String
    private let placeholder: String
    private let lineWidth: Int
    @State private var wrappedLines: [String] = []
    @State private var isEditing: Bool = false
    
    public init(placeholder: String = "Enter text...", text: Binding<String>, lineWidth: Int = 60) {
        self._text = text
        self.placeholder = placeholder
        self.lineWidth = lineWidth
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Editor header
            HStack {
                Text(isEditing ? "Editing (Wrapped)" : "Text Editor (Wrapped)")
                    .foregroundColor(isEditing ? Color.blue : Color.gray)
                Spacer()
                Text("Words: \(wordCount)")
                    .foregroundColor(Color.gray)
            }
            .padding(.horizontal)
            .padding(.bottom, 1)
            
            // Wrapped text display
            VStack(alignment: .leading, spacing: 0) {
                if wrappedLines.isEmpty && text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color.gray)
                        .italic()
                        .padding(.all, 1)
                } else {
                    ForEach(Array(wrappedLines.enumerated()), id: \.offset) { index, line in
                        Text(line.isEmpty ? " " : line)
                            .foregroundColor(Color.white)
                    }
                }
            }
            .border()
            .frame(minHeight: 8)
            
            // Status bar
            HStack {
                Text("Auto-wrapped at \(lineWidth) characters | Words: \(wordCount) | Characters: \(text.count)")
                    .foregroundColor(Color.gray)
                Spacer()
            }
            .padding(.horizontal)
        }
        .onAppear {
            updateWrappedLines()
        }
    }
    
    private var wordCount: Int {
        text.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .count
    }
    
    private func updateWrappedLines() {
        guard !text.isEmpty else {
            wrappedLines = []
            return
        }
        
        let paragraphs = text.components(separatedBy: .newlines)
        var result: [String] = []
        
        for paragraph in paragraphs {
            if paragraph.isEmpty {
                result.append("")
                continue
            }
            
            let words = paragraph.components(separatedBy: .whitespaces)
            var currentLine = ""
            
            for word in words {
                let testLine = currentLine.isEmpty ? word : "\(currentLine) \(word)"
                
                if testLine.count <= lineWidth {
                    currentLine = testLine
                } else {
                    if !currentLine.isEmpty {
                        result.append(currentLine)
                    }
                    currentLine = word
                }
            }
            
            if !currentLine.isEmpty {
                result.append(currentLine)
            }
        }
        
        wrappedLines = result
    }
}

/// A multiline text field for simpler multiline input
public struct MultilineTextField: View {
    @Binding private var text: String
    private let title: String
    private let maxLines: Int
    
    public init(_ title: String, text: Binding<String>, maxLines: Int = 5) {
        self.title = title
        self._text = text
        self.maxLines = maxLines
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(title)
                .foregroundColor(Color.gray)
            
            VStack(alignment: .leading, spacing: 0) {
                let lines = text.isEmpty ? [""] : text.components(separatedBy: .newlines)
                let displayLines = Array(lines.prefix(maxLines))
                
                ForEach(Array(displayLines.enumerated()), id: \.offset) { index, line in
                    Text(line.isEmpty ? " " : line)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Fill remaining lines if needed
                if displayLines.count < maxLines {
                    ForEach(displayLines.count..<maxLines, id: \.self) { _ in
                        Text(" ")
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .border()
            
            HStack {
                Text("Lines: \(text.components(separatedBy: .newlines).count)/\(maxLines)")
                    .foregroundColor(Color.gray)
                Spacer()
                Text("Characters: \(text.count)")
                    .foregroundColor(Color.gray)
            }
        }
    }
}