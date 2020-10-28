import UIKit

/// A type-erased component.
public struct AnyComponent: Component {
    @usableFromInline
    internal let box: AnyComponentBox

    /// A string used to identify a element that is reusable. Default is the type name of `Content`.
    @inlinable
    public var reuseIdentifier: String {
        return box.reuseIdentifier
    }

    /// Create a type-erased component that wraps the given instance.
    ///
    /// - Parameters:
    ///   - base: A component to be wrap.
    @inlinable
    public init<Base: Component>(_ base: Base) {
        if let anyComponent = base as? AnyComponent {
            self = anyComponent
        }
        else {
            box = ComponentBox(base)
        }
    }

    /// Returns a new instance of `Content`.
    ///
    /// - Returns: A new `Content` instance for render on top
    ///            of element of list UI element.
    @inlinable
    public func renderContent() -> Any {
        return box.renderContent()
    }

    /// Render properties into the content on the element of list UI.
    ///
    /// - Parameter:
    ///   - content: An instance of `Content` laid out on the element of list UI.
    @inlinable
    public func render(in content: Any) {
        box.render(in: content)
    }

    /// Returns the referencing size of content to render on the list UI.
    ///
    /// - Parameter:
    ///   - bounds: A value of `CGRect` containing the size of the list UI itself,
    ///             such as `UITableView` or `UICollectionView`.
    ///
    /// - Returns: The referencing size of content to render on the list UI.
    ///            If returns nil, the element of list UI falls back to its default size
    ///            like `UITableView.rowHeight` or `UICollectionViewFlowLayout.itemSize`.
    @inlinable
    public func referenceSize(in bounds: CGRect) -> CGSize? {
        return box.referenceSize(in: bounds)
    }

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
    @inlinable
    public func shouldContentUpdate(with next: AnyComponent) -> Bool {
        return box.shouldContentUpdate(with: next.box)
    }

    /// Returns a `Bool` value indicating whether component should be render again.
    ///
    /// - Parameters:
    ///   - next: The next value to be compared to the receiver.
    ///   - content: An instance of content laid out on the element.
    ///
    /// - Returns: A `Bool` value indicating whether the component should be render again.
    @inlinable
    public func shouldRender(next: AnyComponent, in content: Any) -> Bool {
        return box.shouldRender(next: next.box, in: content)
    }

    /// Layout the content on top of element of the list UI.
    ///
    /// - Note: `UIView` and `UIViewController` are laid out with edge constraints by default.
    ///
    /// - Parameters:
    ///   - content: An instance of content to be laid out on top of element.
    ///   - container: A container view to layout content.
    @inlinable
    public func layout(content: Any, in container: UIView) {
        box.layout(content: content, in: container)
    }

    /// Invoked every time of before a component got into visible area.
    ///
    /// - Parameter:
    ///   - content: An instance of content getting into display area.
    @inlinable
    public func contentWillDisplay(_ content: Any) {
        box.contentWillDisplay(content)
    }

    /// Invoked every time of after a component went out from visible area.
    ///
    /// - Parameter:
    ///   - content: An instance of content going out from display area.
    @inlinable
    public func contentDidEndDisplay(_ content: Any) {
        box.contentDidEndDisplay(content)
    }

    /// Returns a base instance casted as given type if possible.
    ///
    /// - Parameter: An expected type of the base instance to casted.
    /// - Returns: A casted base instance.
    @inlinable
    public func `as`<T>(_: T.Type) -> T? {
        return box.base as? T
    }
}

extension AnyComponent: CustomDebugStringConvertible {
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        return "AnyComponent(\(box.base))"
    }
}

@usableFromInline
internal protocol AnyComponentBox {
    var base: Any { get }
    var reuseIdentifier: String { get }

    func renderContent() -> Any
    func render(in content: Any)
    func referenceSize(in bounds: CGRect) -> CGSize?
    func layout(content: Any, in container: UIView)
    func shouldContentUpdate(with next: AnyComponentBox) -> Bool
    func shouldRender(next: AnyComponentBox, in content: Any) -> Bool

    func contentWillDisplay(_ content: Any)
    func contentDidEndDisplay(_ content: Any)
}

@usableFromInline
internal struct ComponentBox<Base: Component>: AnyComponentBox {
    @usableFromInline
    internal let baseComponent: Base

    @inlinable
    internal var base: Any {
        return baseComponent
    }

    @inlinable
    internal var reuseIdentifier: String {
        return baseComponent.reuseIdentifier
    }

    @inlinable
    internal init(_ base: Base) {
        baseComponent = base
    }

    @inlinable
    internal func renderContent() -> Any {
        return baseComponent.renderContent()
    }

    @inlinable
    internal func render(in content: Any) {
        guard let content = content as? Base.Content else { return }

        baseComponent.render(in: content)
    }

    @inlinable
    internal func referenceSize(in bounds: CGRect) -> CGSize? {
        return baseComponent.referenceSize(in: bounds)
    }

    @inlinable
    internal func layout(content: Any, in container: UIView) {
        guard let content = content as? Base.Content else { return }

        baseComponent.layout(content: content, in: container)
    }

    @inlinable
    func shouldContentUpdate(with next: AnyComponentBox) -> Bool {
        guard let next = next.base as? Base else { return true }

        return baseComponent.shouldContentUpdate(with: next)
    }

    @inlinable
    func shouldRender(next: AnyComponentBox, in content: Any) -> Bool {
        guard let next = next.base as? Base, let content = content as? Base.Content else { return true }

        return baseComponent.shouldRender(next: next, in: content)
    }

    @inlinable
    internal func contentWillDisplay(_ content: Any) {
        guard let content = content as? Base.Content else { return }

        baseComponent.contentWillDisplay(content)
    }

    @inlinable
    internal func contentDidEndDisplay(_ content: Any) {
        guard let content = content as? Base.Content else { return }

        baseComponent.contentDidEndDisplay(content)
    }
}
