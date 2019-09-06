public struct IdentifiedComponentWrapper<ID: Hashable, Wrapped: Component>: IdentifiableComponent, ComponentWrapping {
    public var id: ID
    public var wrapped: Wrapped

    public init(id: ID, wrapped: Wrapped) {
        self.id = id
        self.wrapped = wrapped
    }
}
