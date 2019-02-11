import DifferenceKit

/// The node for view which need not be uniquely identified like header or footer.
/// Erase the type of component and wrapping it.
/// This works as an intermediary for `DifferenceKit`.
public struct ViewNode {
    /// A type-erased component which wrapped in `self`.
    public var component: AnyComponent

    /// Create a node wrapping given component.
    ///
    /// - Parameter
    ///   - component: A component to be wrap.
    @inlinable
    public init<C: Component>(_ component: C) {
        self.component = AnyComponent(component)
    }

    /// Returns a base instance of component casted as given type if possible.
    ///
    /// - Parameter: An expected type of the base instance of component to casted.
    /// - Returns: A casted base instance.
    @inlinable
    public func component<T>(as _: T.Type) -> T? {
        return component.as(T.self)
    }
}

extension ViewNode: ContentEquatable {
    /// Indicate whether the content of `self` is equals to the content of
    /// the given source value.
    @inlinable
    public func isContentEqual(to source: ViewNode) -> Bool {
        return !source.component.shouldContentUpdate(with: component)
    }
}

extension ViewNode: CustomDebugStringConvertible {
    /// A textual representation of this instance, suitable for debugging.
    @inlinable
    public var debugDescription: String {
        return "ViewNode(component: \(component))"
    }
}
