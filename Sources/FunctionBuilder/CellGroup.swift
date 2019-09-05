public struct CellGroup: CellsBuildable {
    private var _buildCells: () -> [CellNode]

    public init<C: CellsBuildable>(@CellsBuilder cells: () -> C) {
        _buildCells = cells().buildCells
    }

    public init<Data: Sequence, C: CellsBuildable>(of data: Data, cell: @escaping (Data.Element) -> C) {
        _buildCells = {
            data.flatMap { element in
                cell(element).buildCells()
            }
        }
    }

    public func buildCells() -> [CellNode] {
        _buildCells()
    }
}
