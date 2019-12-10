/// An affordance for grouping component or section.
///
/// Example for simple grouping of cells.
///
///     Group {
///         Label("Cell 0")
///
///         Label("Cell 1")
///
///         Label("Cell 2")
///     }
public struct Group<Element> {
    @usableFromInline
    internal var elements: [Element]

    /// Creates a group without elements.
    public init() {
        elements = []
    }
}

extension Group: CellsBuildable where Element == CellNode {
    /// Creates a group with given cells.
    ///
    /// - Parameter
    ///   - cells: A closure that constructs cells.
    public init<C: CellsBuildable>(@CellsBuilder cells: () -> C) {
        elements = cells().buildCells()
    }

    /// Creates a group with cells mapped from given elements.
    ///
    /// - Parameter
    ///   - data: The sequence of elements to be mapped to cells.
    ///   - cell: A closure to create a cell with passed element.
    public init<Data: Sequence, C: CellsBuildable>(of data: Data, cell: (Data.Element) -> C) {
        elements = data.flatMap { element in
            cell(element).buildCells()
        }
    }

    /// Build an array of cell.
    ///
    /// - Returns: An array of cell.
    public func buildCells() -> [CellNode] {
        elements
    }
}

extension Group: SectionsBuildable where Element == Section {
    /// Creates a group with given sections.
    ///
    /// - Parameter
    ///   - sections: A closure that constructs sections.
    public init<S: SectionsBuildable>(@SectionsBuilder sections: () -> S) {
        elements = sections().buildSections()
    }

    /// Creates a group with sections mapped from given elements.
    ///
    /// - Parameter
    ///   - data: The sequence of elements to be mapped to sections.
    ///   - section: A closure to create a section with passed element.
    public init<Data: Sequence, S: SectionsBuildable>(of data: Data, section: (Data.Element) -> S) {
        elements = data.flatMap { element in
            section(element).buildSections()
        }
    }

    /// Build an array of section.
    ///
    /// - Returns: An array of section.
    public func buildSections() -> [Section] {
        elements
    }
}
