public struct Group<Element> {
    private var elements: [Element]

    private init() {
        elements = []
    }
}

extension Group: CellsBuildable where Element == CellNode {
    public init<C: CellsBuildable>(@CellsBuilder cells: () -> C) {
        elements = cells().buildCells()
    }

    public init<Data: Sequence, C: CellsBuildable>(of data: Data, cell: (Data.Element) -> C) {
        elements = data.flatMap { element in
            cell(element).buildCells()
        }
    }

    public func buildCells() -> [CellNode] {
        elements
    }
}

extension Group: SectionsBuildable where Element == Section {
    public init<S: SectionsBuildable>(@SectionsBuilder sections: () -> S) {
        elements = sections().buildSections()
    }

    public init<Data: Sequence, S: SectionsBuildable>(of data: Data, section: (Data.Element) -> S) {
        elements = data.flatMap { element in
            section(element).buildSections()
        }
    }

    public func buildSections() -> [Section] {
        elements
    }
}
