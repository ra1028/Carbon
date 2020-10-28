import DifferenceKit

/// The node for cell that can be uniquely identified.
/// Wrapping type-erased identifier and component.
/// This works as an intermediary for `DifferenceKit`.
public struct CellNode {
    /// A type-erased identifier that can be used to uniquely
    /// identify the component.
    public var id: AnyHashable

    /// A type-erased component which wrapped in `self`.
    public var component: AnyComponent

    /// Create a node wrapping given id and component.
    ///
    /// - Parameters:
    ///   - id: An identifier to be wrapped.
    ///   - component: A component to be wrapped.
    @inlinable
    public init<I: Hashable, C: Component>(id: I, _ component: C) {
        // This is workaround for avoid redundant `AnyHashable` wrapping.
        if type(of: id) == AnyHashable.self {
            self.id = unsafeBitCast(id, to: AnyHashable.self)
        }
        else {
            self.id = id
        }

        self.component = AnyComponent(component)
    }

    /// Create a node wrapping given component and its id.
    ///
    /// - Parameter
    ///   - component: A component to be wrapped that can be uniquely identified.
    @inlinable
    public init<C: IdentifiableComponent>(_ component: C) {
        self.init(id: component.id, component)
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

extension CellNode: Differentiable {
    /// An identifier value for difference calculation.
    @inlinable
    public var differenceIdentifier: AnyHashable {
        return id
    }

    /// Indicate whether the content of `self` is equals to the content of
    /// the given source value.
    @inlinable
    public func isContentEqual(to source: CellNode) -> Bool {
        return !source.component.shouldContentUpdate(with: component)
    }
}

extension CellNode: CustomDebugStringConvertible {
    /// A textual representation of this instance, suitable for debugging.
    @inlinable
    public var debugDescription: String {
        return "CellNode(id: \(id), component: \(component))"
    }
}
