/// Represents a component that can be uniquely identify.
///
/// Example for the simple identified component:
///
///     struct UserLabel: IdentifiableComponent {
///         var id: Int64
///         var name: String
///
///         func renderContent() -> UILabel {
///             return UILabel()
///         }
///
///         func render(in content: UILabel) {
///             content.text = name
///         }
///     }
///
///     let view = ViewNode(UserLabel(id: 0, name: "John"))
///     let cell = CellNode(UserLabel(id: 0, name: "Jane"))
public protocol IdentifiableComponent: Component, CellsBuildable {
    /// A type that represents an id that used to uniquely identify the component.
    associatedtype ID: Hashable

    /// An identifier that used to uniquely identify the component.
    var id: ID { get }
}

public extension IdentifiableComponent {
    func buildCells() -> [CellNode] {
        return [CellNode(self)]
    }
}

public extension IdentifiableComponent where Self: Hashable {
    /// An identifier that can be used to uniquely identify the component.
    /// Default is `self`.
    var id: Self {
        return self
    }
}
