/// Represents an instance that can build cells.
public protocol CellsBuildable {
    /// Build an array of cell.
    func buildCells() -> [CellNode]
}

extension Optional: CellsBuildable where Wrapped: CellsBuildable {
    /// Build an array of cell.
    @inlinable
    public func buildCells() -> [CellNode] {
        return self?.buildCells() ?? []
    }
}
