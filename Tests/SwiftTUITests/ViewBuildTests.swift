import Testing
@testable import SwiftTUI

@Suite("View Build Tests")
@MainActor
struct ViewBuildTests {
    @Test("VStack with TupleView2 builds correctly")
    func vstackTupleView2() throws {
        struct MyView: View {
            var body: some View {
                VStack {
                    Text("One")
                    Text("Two")
                }
            }
        }

        let control = try buildView(MyView())

        #expect(control.treeDescription == """
            → VStackControl
              → TextControl
              → TextControl
            """)
    }

    @Test("Conditional VStack builds correctly")
    func conditionalVStack() throws {
        struct MyView: View {
            @State var value = true

            var body: some View {
                if value {
                    VStack {
                        Text("One")
                    }
                }
            }
        }

        let control = try buildView(MyView())

        #expect(control.treeDescription == """
            → VStackControl
              → TextControl
            """)
    }

    private func buildView<V: View>(_ view: V) throws -> Control {
        let node = Node(view: VStack(content: view).view)
        node.build()
        guard let control = node.control?.children.first else {
            throw TestError.missingControl
        }
        return control
    }
    
    private enum TestError: Error {
        case missingControl
    }
}
