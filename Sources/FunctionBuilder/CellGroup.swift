public struct CellGroup: CellsBuildable {
    private var _buildCells: () -> [CellNode]

    public init<C: CellsBuildable>(@CellsBuilder _ cells: @escaping () -> C) {
        _buildCells = cells().buildCells
    }

    public init<Seq: Sequence, C: CellsBuildable>(of sequence: Seq, cell: @escaping (Seq.Element) -> C) {
        _buildCells = {
            sequence.flatMap { element in
                cell(element).buildCells()
            }
        }
    }

    public func buildCells() -> [CellNode] {
        _buildCells()
    }
}
