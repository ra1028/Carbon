/// Represents a component that can be uniquely identify.
///
/// Example for the simple identified component:
///
///     struct UserLabel: IdentifiableComponent, Equatable {
///         var userID: Int64
///         var name: String
///
///         var id: Int64 {
///             return userID
///         }
///
///         func renderContent() -> UILabel {
///             return UILabel()
///         }
///
///         func render(in content: UILabel) {
///             content.text = name
///         }
///
///         func referenceSize(in bounds: CGRect) -> CGSize? {
///             return CGSize(width: bounds.width, height: 44)
///         }
///     }
///
///     let view = ViewNode(UserLabel(userID: 0, name: "John"))
///     let cell = CellNode(UserLabel(userID: 0, name: "Jane"))
public protocol IdentifiableComponent: Component {
    /// A type that represents an id that used to uniquely identify the component.
    associatedtype ID: Hashable

    /// An identifier that used to uniquely identify the component.
    var id: ID { get }
}

public extension IdentifiableComponent where Self: Hashable {
    /// An identifier that can be used to uniquely identify the component.
    /// Default is `self`.
    var id: Self {
        return self
    }
}
