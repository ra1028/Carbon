import XCTest
@testable import Carbon

final class CellsBuildableTests: XCTestCase {
    func testBuildCells() {
        let componentA = A.Component()
        let componentB = B.Component()
        let c = MockCellsBuildable(
            cells: [
                CellNode(componentA),
                CellNode(componentB)
            ]
        )
        let cells = c.buildCells()

        XCTAssertEqual(cells.count, 2)
        XCTAssertEqual(cells[0].component(as: A.Component.self), componentA)
        XCTAssertEqual(cells[1].component(as: B.Component.self), componentB)
    }

    func testBuildCellsFromSome() {
        let componentA = A.Component()
        let componentB = B.Component()
        let c: MockCellsBuildable? = MockCellsBuildable(
            cells: [
                CellNode(componentA),
                CellNode(componentB)
            ]
        )
        let cells = c.buildCells()

        XCTAssertEqual(cells.count, 2)
        XCTAssertEqual(cells[0].component(as: A.Component.self), componentA)
        XCTAssertEqual(cells[1].component(as: B.Component.self), componentB)
    }

    func testBuildCellsFromNone() {
        let c: MockCellsBuildable? = nil
        let cells = c.buildCells()

        XCTAssertTrue(cells.isEmpty)
    }
}
