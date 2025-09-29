import Foundation

/// This is the interface to any view as the view graph is concerned.
///
/// Such a generic view can be either a `PrimitiveNodeViewBuilder`, meaning it has custom logic to build
/// and update the nodes, or a `ComposedNodeViewBuilder`, meaning it is created using the familiar `View`
/// struct.
@MainActor
protocol NodeViewBuilder {
    func buildNode(_ node: Node)
    func updateNode(_ node: Node)
    static var size: Int? { get }
}
