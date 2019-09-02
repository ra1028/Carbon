// swiftlint:disable line_length
// swiftlint:disable function_parameter_count

@_functionBuilder
public struct CellsBuilder: CellsBuildable {
    private var cellNodes: [CellNode]

    public func buildCells() -> [CellNode] {
        cellNodes
    }

    public static func buildBlock() -> CellsBuilder {
        CellsBuilder()
    }

    public static func buildBlock<C: CellsBuildable>(_ c: C) -> CellsBuilder {
        CellsBuilder(c)
    }

    public static func buildBlock<C0: CellsBuildable, C1: CellsBuildable>(_ c0: C0, _ c1: C1) -> CellsBuilder {
        CellsBuilder(c0, c1)
    }

    public static func buildBlock<C0: CellsBuildable, C1: CellsBuildable, C2: CellsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2) -> CellsBuilder {
        CellsBuilder(c0, c1, c2)
    }

    public static func buildBlock<C0: CellsBuildable, C1: CellsBuildable, C2: CellsBuildable, C3: CellsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> CellsBuilder {
        CellsBuilder(c0, c1, c2, c3)
    }

    public static func buildBlock<C0: CellsBuildable, C1: CellsBuildable, C2: CellsBuildable, C3: CellsBuildable, C4: CellsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> CellsBuilder {
        CellsBuilder(c0, c1, c2, c3, c4)
    }

    public static func buildBlock<C0: CellsBuildable, C1: CellsBuildable, C2: CellsBuildable, C3: CellsBuildable, C4: CellsBuildable, C5: CellsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> CellsBuilder {
        CellsBuilder(c0, c1, c2, c3, c4, c5)
    }

    public static func buildBlock<C0: CellsBuildable, C1: CellsBuildable, C2: CellsBuildable, C3: CellsBuildable, C4: CellsBuildable, C5: CellsBuildable, C6: CellsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> CellsBuilder {
        CellsBuilder(c0, c1, c2, c3, c4, c5, c6)
    }

    public static func buildBlock<C0: CellsBuildable, C1: CellsBuildable, C2: CellsBuildable, C3: CellsBuildable, C4: CellsBuildable, C5: CellsBuildable, C6: CellsBuildable, C7: CellsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> CellsBuilder {
        CellsBuilder(c0, c1, c2, c3, c4, c5, c6, c7)
    }

    public static func buildBlock<C0: CellsBuildable, C1: CellsBuildable, C2: CellsBuildable, C3: CellsBuildable, C4: CellsBuildable, C5: CellsBuildable, C6: CellsBuildable, C7: CellsBuildable, C8: CellsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> CellsBuilder {
        CellsBuilder(c0, c1, c2, c3, c4, c5, c6, c7, c8)
    }

    public static func buildBlock<C0: CellsBuildable, C1: CellsBuildable, C2: CellsBuildable, C3: CellsBuildable, C4: CellsBuildable, C5: CellsBuildable, C6: CellsBuildable, C7: CellsBuildable, C8: CellsBuildable, C9: CellsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> CellsBuilder {
        CellsBuilder(c0, c1, c2, c3, c4, c5, c6, c7, c8, c9)
    }

    public static func buildIf<C: CellsBuildable>(_ c: C?) -> C? {
        c
    }

    public static func buildEither<C: CellsBuildable>(first: C) -> C {
        first
    }

    public static func buildEither<C: CellsBuildable>(second: C) -> C {
        second
    }
}

private extension CellsBuilder {
    init() {
        cellNodes = []
    }

    init<C: CellsBuildable>(_ c: C) {
        cellNodes = c.buildCells()
    }

    init<C0: CellsBuildable, C1: CellsBuildable>(_ c0: C0, _ c1: C1) {
        cellNodes = c0.buildCells() + c1.buildCells()
    }

    init<C0: CellsBuildable, C1: CellsBuildable, C2: CellsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2) {
        cellNodes = c0.buildCells() + c1.buildCells() + c2.buildCells()
    }

    init<C0: CellsBuildable, C1: CellsBuildable, C2: CellsBuildable, C3: CellsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) {
        let cellNodes0 = c0.buildCells() + c1.buildCells() + c2.buildCells()
        let cellNodes1 = c3.buildCells()
        cellNodes = cellNodes0 + cellNodes1
    }

    init<C0: CellsBuildable, C1: CellsBuildable, C2: CellsBuildable, C3: CellsBuildable, C4: CellsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) {
        let cellNodes0 = c0.buildCells() + c1.buildCells() + c2.buildCells()
        let cellNodes1 = c3.buildCells() + c4.buildCells()
        cellNodes = cellNodes0 + cellNodes1
    }

    init<C0: CellsBuildable, C1: CellsBuildable, C2: CellsBuildable, C3: CellsBuildable, C4: CellsBuildable, C5: CellsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) {
        let cellNodes0 = c0.buildCells() + c1.buildCells() + c2.buildCells()
        let cellNodes1 = c3.buildCells() + c4.buildCells() + c5.buildCells()
        cellNodes = cellNodes0 + cellNodes1
    }

    init<C0: CellsBuildable, C1: CellsBuildable, C2: CellsBuildable, C3: CellsBuildable, C4: CellsBuildable, C5: CellsBuildable, C6: CellsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) {
        let cellNodes0 = c0.buildCells() + c1.buildCells() + c2.buildCells()
        let cellNodes1 = c3.buildCells() + c4.buildCells() + c5.buildCells()
        let cellNodes2 = c6.buildCells()
        cellNodes = cellNodes0 + cellNodes1 + cellNodes2
    }

    init<C0: CellsBuildable, C1: CellsBuildable, C2: CellsBuildable, C3: CellsBuildable, C4: CellsBuildable, C5: CellsBuildable, C6: CellsBuildable, C7: CellsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) {
        let cellNodes0 = c0.buildCells() + c1.buildCells() + c2.buildCells()
        let cellNodes1 = c3.buildCells() + c4.buildCells() + c5.buildCells()
        let cellNodes2 = c6.buildCells() + c7.buildCells()
        cellNodes = cellNodes0 + cellNodes1 + cellNodes2
    }

    init<C0: CellsBuildable, C1: CellsBuildable, C2: CellsBuildable, C3: CellsBuildable, C4: CellsBuildable, C5: CellsBuildable, C6: CellsBuildable, C7: CellsBuildable, C8: CellsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) {
        let cellNodes0 = c0.buildCells() + c1.buildCells() + c2.buildCells()
        let cellNodes1 = c3.buildCells() + c4.buildCells() + c5.buildCells()
        let cellNodes2 = c6.buildCells() + c7.buildCells() + c8.buildCells()
        cellNodes = cellNodes0 + cellNodes1 + cellNodes2
    }

    init<C0: CellsBuildable, C1: CellsBuildable, C2: CellsBuildable, C3: CellsBuildable, C4: CellsBuildable, C5: CellsBuildable, C6: CellsBuildable, C7: CellsBuildable, C8: CellsBuildable, C9: CellsBuildable>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) {
        let cellNodes0 = c0.buildCells() + c1.buildCells() + c2.buildCells()
        let cellNodes1 = c3.buildCells() + c4.buildCells() + c5.buildCells()
        let cellNodes2 = c6.buildCells() + c7.buildCells() + c8.buildCells()
        cellNodes = cellNodes0 + cellNodes1 + cellNodes2 + c9.buildCells()
    }
}
