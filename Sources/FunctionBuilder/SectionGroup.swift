public struct SectionGroup: SectionsBuildable {
    private var sections: [Section]

    public init<S: SectionsBuildable>(@SectionsBuilder sections: () -> S) {
        self.sections = sections().buildSections()
    }

    public init<C: CellsBuildable>(@CellsBuilder cells: () -> C) {
        sections = [
            Section(id: UniqueIdentifier(), cells: cells)
        ]
    }

    public init<Data: Sequence, S: SectionsBuildable>(of data: Data, section: (Data.Element) -> S) {
        sections = data.flatMap { element in
            section(element).buildSections()
        }
    }

    public init<Data: Sequence, C: CellsBuildable>(of data: Data, cell: (Data.Element) -> C) {
        self.init {
            CellGroup(of: data, cell: cell)
        }
    }

    public func buildSections() -> [Section] {
        sections
    }
}

private struct UniqueIdentifier: Hashable {}
