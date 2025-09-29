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
    Application(rootView: contentView).start()
  }

  var contentView: some View {
    Text("Hello world!")
  }
}
