public struct CellGroup: CellsBuildable {
    private var cells: [CellNode]

    public init<C: CellsBuildable>(@CellsBuilder cells: () -> C) {
        self.cells = cells().buildCells()
    }

    public init<Data: Sequence, C: CellsBuildable>(of data: Data, cell: (Data.Element) -> C) {
        cells = data.flatMap { element in
            cell(element).buildCells()
        }
    }

    public func buildCells() -> [CellNode] {
        cells
    }
}
