public protocol CellsBuildable {
    func buildCells() -> [CellNode]
}

extension Optional: CellsBuildable where Wrapped: CellsBuildable {
    public func buildCells() -> [CellNode] {
        self?.buildCells() ?? []
    }
}
