import UIKit

/// Represents a component of a list UI such as `UITableView` or `UICollectionView`.
///
/// - Note: Components are designed to be available for `UITableView`, `UICollectionView`,
///         and its cell, header, footer, and other generally elements.
///
/// Example for the simple component:
///
///     struct Label: Component, Equatable {
///         var text: String
///
///         func renderContent() -> UILabel {
///             return UILabel()
///         }
///
///         func render(in content: UILabel) {
///             content.text = text
///         }
///
///         func referenceSize(in bounds: CGRect) -> CGSize? {
///             return CGSize(width: bounds.width, height: 44)
///         }
///     }
///
///     let view = ViewNode(Label(text: "Hello"))
///     let cell = CellNode(id: 0, Label(text: "World"))
public protocol Component {
    /// A type that represents a content to be render on the element of list UI.
    associatedtype Content

    // MARK: - Rendering - required

    /// Returns a new instance of `Content`.
    ///
    /// - Returns: A new `Content` instance.
    func renderContent() -> Content

    /// Render properties into the content.
    ///
    /// - Parameter:
    ///   - content: An instance of `Content` laid out on the element of list UI.
    func render(in content: Content)

    /// Returns the referencing size of content to render on the list UI.
    ///
    /// - Parameter:
    ///   - bounds: A value of `CGRect` containing the size of the list UI itself,
    ///             such as `UITableView` or `UICollectionView`.
    ///
    /// - Note: Only `CGSize.height` is used to determine the size of element
    ///         in `UITableView`.
    ///
    /// - Returns: The referencing size of content to render on the list UI.
    ///            If returns nil, the element of list UI falls back to its default size
    ///            like `UITableView.rowHeight` or `UICollectionViewFlowLayout.itemSize`.
    func referenceSize(in bounds: CGRect) -> CGSize?

    /// Returns a `Bool` value indicating whether the content should be reloaded.
    ///
    /// - Note: Unlike `Equitable`, this doesn't compare whether the two values
    ///         exactly equal. It's can be ignore property comparisons, if not expect
    ///         to reload content.
    ///
    /// - Parameter:
    ///   - next: The next value to be compared to the receiver.
    ///
    /// - Returns: A `Bool` value indicating whether the content should be reloaded.
    func shouldContentUpdate(with next: Self) -> Bool

    // MARK: - Rendering - optional

    /// A string used to identify a element that is reusable. Default is the type name of `Content`.
    var reuseIdentifier: String { get }

    /// Returns a `Bool` value indicating whether component should be render again.
    ///
    /// - Parameters:
    ///   - next: The next value to be compared to the receiver.
    ///   - content: An instance of content laid out on the element.
    ///
    /// - Returns: A `Bool` value indicating whether the component should be render again.
    func shouldRender(next: Self, in content: Content) -> Bool

    /// Layout the content on top of element of the list UI.
    ///
    /// - Note: `UIView` and `UIViewController` are laid out with edge constraints by default.
    ///
    /// - Parameters:
    ///   - content: An instance of content to be laid out on top of element.
    ///   - container: A container view to layout content.
    func layout(content: Content, in container: UIView)

    // MARK: - Lifecycle - optional

    /// Invoked every time of before a component got into visible area.
    ///
    /// - Parameter:
    ///   - content: An instance of content getting into display area.
    func contentWillDisplay(_ content: Content)

    /// Invoked every time of after a component went out from visible area.
    ///
    /// - Parameter:
    ///   - content: An instance of content going out from display area.
    func contentDidEndDisplay(_ content: Content)
}

public extension Component {
    /// A string used to identify a element that is reusable. Default is the type name of `Content`.
    @inlinable
    var reuseIdentifier: String {
        return String(reflecting: Content.self)
    }

    /// Returns a `Bool` value indicating whether component should be render again.
    ///
    /// - Parameters:
    ///   - next: The next value to be compared to the receiver.
    ///   - content: An instance of content laid out on the element.
    ///
    /// - Returns: A `Bool` value indicating whether the component should be render again.
    @inlinable
    func shouldRender(next: Self, in content: Content) -> Bool {
        return true
    }

    /// Invoked every time of before a component got into visible area.
    ///
    /// - Parameter:
    ///   - content: An instance of content getting into display area.
    @inlinable
    func contentWillDisplay(_ content: Content) {}

    /// Invoked every time of after a component went out from visible area.
    ///
    /// - Parameter:
    ///   - content: An instance of content going out from display area.
    @inlinable
    func contentDidEndDisplay(_ content: Content) {}
}

public extension Component where Self: Equatable {
    /// Returns a `Bool` value indicating whether the content should be reloaded.
    ///
    /// - Parameter:
    ///   - next: The next value to be compared to the receiver.
    ///
    /// - Returns: A `Bool` value indicating whether the content should be reloaded.
    ///            Default is the result of comparison by `Equatable.==`.
    @inlinable
    func shouldContentUpdate(with next: Self) -> Bool {
        return self != next
    }
}

public extension Component where Content: UIView {
    /// Layout the content on top of element of the list UI.
    ///
    /// - Parameters:
    ///   - content: An instance of content to be laid out on top of element.
    ///   - container: A container view to layout content.
    ///                Default is laid out with edge constraints.
    func layout(content: Content, in container: UIView) {
        container.addSubviewWithEdgeConstraints(content)
    }
}

public extension Component where Content: UIViewController {
    /// Layout the content on top of element of the list UI.
    ///
    /// - Parameters:
    ///   - content: An instance of content to be laid out on top of element.
    ///   - container: A container view to layout content.
    ///                Default is laid out with edge constraints.
    func layout(content: Content, in container: UIView) {
        container.addSubviewWithEdgeConstraints(content.view)
    }
}

private extension UIView {
    func addSubviewWithEdgeConstraints(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        let bottomConstraint = bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let trailingConstraint = trailingAnchor.constraint(equalTo: view.trailingAnchor)

        // Setting the priority lower than `UILayoutPriority.required` prevents
        // header view from becoming an ambiguous constraint.
        // This may cause other unknown layout failures.
        // If you can found it, please report it by GitHub issue.
        let priority = UILayoutPriority(999)
        bottomConstraint.priority = priority
        trailingConstraint.priority = priority

        let constraints = [
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomConstraint,
            trailingConstraint
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
