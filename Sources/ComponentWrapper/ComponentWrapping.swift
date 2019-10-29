import UIKit

/// Represents a wrapper of component that forwards all actions to wrapped component.
/// You can easily conform arbitrary type to `Component` protocol by wrapping component instance.
@dynamicMemberLookup
public protocol ComponentWrapping: Component {
    /// The type of wrapped component.
    associatedtype Wrapped: Component

    /// The wrapped component instance.
    var wrapped: Wrapped { get }
}

public extension ComponentWrapping {
    /// Accesses a member of wrapped component with key path.
    @inlinable
    subscript<T>(dynamicMember keyPath: KeyPath<Wrapped, T>) -> T {
        wrapped[keyPath: keyPath]
    }
}

public extension ComponentWrapping {
    /// A string used to identify a element that is reusable. Default is the type name of `self`.
    @inlinable
    var reuseIdentifier: String {
        return wrapped.reuseIdentifier
    }

    /// Returns a new instance of `Content`.
    ///
    /// - Returns: A new `Content` instance.
    @inlinable
    func renderContent() -> Wrapped.Content {
        return wrapped.renderContent()
    }

    /// Render properties into the content.
    ///
    /// - Parameter:
    ///   - content: An instance of `Content` laid out on the element of list UI.
    @inlinable
    func render(in content: Wrapped.Content) {
        wrapped.render(in: content)
    }

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
    @inlinable
    func referenceSize(in bounds: CGRect) -> CGSize? {
        return wrapped.referenceSize(in: bounds)
    }

    /// Returns a `Bool` value indicating whether the content should be reloaded.
    ///
    /// - Note: Unlike `Equatable`, this doesn't compare whether the two values
    ///         exactly equal. It's can be ignore property comparisons, if not expect
    ///         to reload content.
    ///
    /// - Parameter:
    ///   - next: The next value to be compared to the receiver.
    ///
    /// - Returns: A `Bool` value indicating whether the content should be reloaded.
    @inlinable
    func shouldContentUpdate(with next: Self) -> Bool {
        return wrapped.shouldContentUpdate(with: next.wrapped)
    }

    /// Returns a `Bool` value indicating whether component should be render again.
    ///
    /// - Parameters:
    ///   - next: The next value to be compared to the receiver.
    ///   - content: An instance of content laid out on the element.
    ///
    /// - Returns: A `Bool` value indicating whether the component should be render again.
    @inlinable
    func shouldRender(next: Self, in content: Wrapped.Content) -> Bool {
        return wrapped.shouldRender(next: next.wrapped, in: content)
    }

    /// Layout the content on top of element of the list UI.
    ///
    /// - Note: `UIView` and `UIViewController` are laid out with edge constraints by default.
    ///
    /// - Parameters:
    ///   - content: An instance of content to be laid out on top of element.
    ///   - container: A container view to layout content.
    @inlinable
    func layout(content: Wrapped.Content, in container: UIView) {
        wrapped.layout(content: content, in: container)
    }

    /// The natural size for the passed content.
    ///
    /// - Parameter:
    ///   - content: An instance of content.
    ///
    /// - Returns: A `CGSize` value represents a natural size of the passed content.
    func intrinsicContentSize(for content: Wrapped.Content) -> CGSize {
        return wrapped.intrinsicContentSize(for: content)
    }

    /// Invoked every time of before a component got into visible area.
    ///
    /// - Parameter:
    ///   - content: An instance of content getting into display area.
    @inlinable
    func contentWillDisplay(_ content: Wrapped.Content) {
        wrapped.contentWillDisplay(content)
    }

    /// Invoked every time of after a component went out from visible area.
    ///
    /// - Parameter:
    ///   - content: An instance of content going out from display area.
    @inlinable
    func contentDidEndDisplay(_ content: Wrapped.Content) {
        wrapped.contentDidEndDisplay(content)
    }
}
