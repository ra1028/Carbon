public struct SectionGroup: SectionsBuildable {
    private var _buildSections: () -> [Section]

    public init<S: SectionsBuildable>(@SectionsBuilder sections: () -> S) {
        _buildSections = sections().buildSections
    }

    public init<C: CellsBuildable>(@CellsBuilder cells: () -> C) {
        let cells = cells()

        self.init {
            Section(id: UniqueIdentifier()) {
                cells
            }
        }
    }

    public init<Data: Sequence, S: SectionsBuildable>(of data: Data, section: @escaping (Data.Element) -> S) {
        _buildSections = {
            data.flatMap { element in
                section(element).buildSections()
            }
        }
    }

    public init<Data: Sequence, C: CellsBuildable>(of data: Data, cell: @escaping (Data.Element) -> C) {
        self.init {
            CellGroup(of: data, cell: cell)
        }
    }

    public func buildSections() -> [Section] {
        _buildSections()
    }
}

private struct UniqueIdentifier: Hashable {}
