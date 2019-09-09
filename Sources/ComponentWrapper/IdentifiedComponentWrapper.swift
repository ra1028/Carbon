public struct IdentifiedComponentWrapper<ID: Hashable, Wrapped: Component>: ComponentWrapping, IdentifiableComponent {
    public var id: ID
    public var wrapped: Wrapped

    public init(id: ID, wrapped: Wrapped) {
        self.id = id
        self.wrapped = wrapped
    }
}

public extension Component {
    func identified<ID: Hashable>(by id: ID) -> IdentifiedComponentWrapper<ID, Self> {
        IdentifiedComponentWrapper(id: id, wrapped: self)
    }

    func identified<ID: Hashable>(by keyPath: KeyPath<Self, ID>) -> IdentifiedComponentWrapper<ID, Self> {
        identified(by: self[keyPath: keyPath])
    }
}
