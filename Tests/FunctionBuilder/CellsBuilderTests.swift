#if swift(>=5.1)

import XCTest
@testable import Carbon

final class CellsBuilderTests: XCTestCase {
    func testInit0() {
        let builders = [
            CellsBuilder(),
            CellsBuilder.buildBlock()
        ]

        for builder in builders {
            let cells = builder.buildCells()

            XCTAssertTrue(cells.isEmpty)
        }
    }

    func testInit1() {
        let c = A.Component()
        let builders = [
            CellsBuilder(c),
            CellsBuilder.buildBlock(c)
        ]

        for builder in builders {
            let cells = builder.buildCells()

            XCTAssertEqual(cells.count, 1)
            XCTAssertEqual(cells[0].component(as: A.Component.self), c)
        }
    }

    func testInit2() {
        let c0 = A.Component(value: 0)
        let c1 = A.Component(value: 1)
        let builders = [
            CellsBuilder(c0, c1),
            CellsBuilder.buildBlock(c0, c1)
        ]

        for builder in builders {
            let cells = builder.buildCells()

            XCTAssertEqual(cells.count, 2)
            XCTAssertEqual(cells[0].component(as: A.Component.self), c0)
            XCTAssertEqual(cells[1].component(as: A.Component.self), c1)
        }
    }

    func testInit3() {
        let c0 = A.Component(value: 0)
        let c1 = A.Component(value: 1)
        let c2 = A.Component(value: 2)
        let builders = [
            CellsBuilder(c0, c1, c2),
            CellsBuilder.buildBlock(c0, c1, c2)
        ]

        for builder in builders {
            let cells = builder.buildCells()

            XCTAssertEqual(cells.count, 3)
            XCTAssertEqual(cells[0].component(as: A.Component.self), c0)
            XCTAssertEqual(cells[1].component(as: A.Component.self), c1)
            XCTAssertEqual(cells[2].component(as: A.Component.self), c2)
        }
    }

    func testInit4() {
        let c0 = A.Component(value: 0)
        let c1 = A.Component(value: 1)
        let c2 = A.Component(value: 2)
        let c3 = A.Component(value: 3)
        let builders = [
            CellsBuilder(c0, c1, c2, c3),
            CellsBuilder.buildBlock(c0, c1, c2, c3)
        ]

        for builder in builders {
            let cells = builder.buildCells()

            XCTAssertEqual(cells.count, 4)
            XCTAssertEqual(cells[0].component(as: A.Component.self), c0)
            XCTAssertEqual(cells[1].component(as: A.Component.self), c1)
            XCTAssertEqual(cells[2].component(as: A.Component.self), c2)
            XCTAssertEqual(cells[3].component(as: A.Component.self), c3)
        }
    }

    func testInit5() {
        let c0 = A.Component(value: 0)
        let c1 = A.Component(value: 1)
        let c2 = A.Component(value: 2)
        let c3 = A.Component(value: 3)
        let c4 = A.Component(value: 4)
        let builders = [
            CellsBuilder(c0, c1, c2, c3, c4),
            CellsBuilder.buildBlock(c0, c1, c2, c3, c4)
        ]

        for builder in builders {
            let cells = builder.buildCells()

            XCTAssertEqual(cells.count, 5)
            XCTAssertEqual(cells[0].component(as: A.Component.self), c0)
            XCTAssertEqual(cells[1].component(as: A.Component.self), c1)
            XCTAssertEqual(cells[2].component(as: A.Component.self), c2)
            XCTAssertEqual(cells[3].component(as: A.Component.self), c3)
            XCTAssertEqual(cells[4].component(as: A.Component.self), c4)
        }
    }

    func testInit6() {
        let c0 = A.Component(value: 0)
        let c1 = A.Component(value: 1)
        let c2 = A.Component(value: 2)
        let c3 = A.Component(value: 3)
        let c4 = A.Component(value: 4)
        let c5 = A.Component(value: 5)
        let builders = [
            CellsBuilder(c0, c1, c2, c3, c4, c5),
            CellsBuilder.buildBlock(c0, c1, c2, c3, c4, c5)
        ]

        for builder in builders {
            let cells = builder.buildCells()

            XCTAssertEqual(cells.count, 6)
            XCTAssertEqual(cells[0].component(as: A.Component.self), c0)
            XCTAssertEqual(cells[1].component(as: A.Component.self), c1)
            XCTAssertEqual(cells[2].component(as: A.Component.self), c2)
            XCTAssertEqual(cells[3].component(as: A.Component.self), c3)
            XCTAssertEqual(cells[4].component(as: A.Component.self), c4)
            XCTAssertEqual(cells[5].component(as: A.Component.self), c5)
        }
    }

    func testInit7() {
        let c0 = A.Component(value: 0)
        let c1 = A.Component(value: 1)
        let c2 = A.Component(value: 2)
        let c3 = A.Component(value: 3)
        let c4 = A.Component(value: 4)
        let c5 = A.Component(value: 5)
        let c6 = A.Component(value: 6)
        let builders = [
            CellsBuilder(c0, c1, c2, c3, c4, c5, c6),
            CellsBuilder.buildBlock(c0, c1, c2, c3, c4, c5, c6)
        ]

        for builder in builders {
            let cells = builder.buildCells()

            XCTAssertEqual(cells.count, 7)
            XCTAssertEqual(cells[0].component(as: A.Component.self), c0)
            XCTAssertEqual(cells[1].component(as: A.Component.self), c1)
            XCTAssertEqual(cells[2].component(as: A.Component.self), c2)
            XCTAssertEqual(cells[3].component(as: A.Component.self), c3)
            XCTAssertEqual(cells[4].component(as: A.Component.self), c4)
            XCTAssertEqual(cells[5].component(as: A.Component.self), c5)
            XCTAssertEqual(cells[6].component(as: A.Component.self), c6)
        }
    }

    func testInit8() {
        let c0 = A.Component(value: 0)
        let c1 = A.Component(value: 1)
        let c2 = A.Component(value: 2)
        let c3 = A.Component(value: 3)
        let c4 = A.Component(value: 4)
        let c5 = A.Component(value: 5)
        let c6 = A.Component(value: 6)
        let c7 = A.Component(value: 7)
        let builders = [
            CellsBuilder(c0, c1, c2, c3, c4, c5, c6, c7),
            CellsBuilder.buildBlock(c0, c1, c2, c3, c4, c5, c6, c7)
        ]

        for builder in builders {
            let cells = builder.buildCells()

            XCTAssertEqual(cells.count, 8)
            XCTAssertEqual(cells[0].component(as: A.Component.self), c0)
            XCTAssertEqual(cells[1].component(as: A.Component.self), c1)
            XCTAssertEqual(cells[2].component(as: A.Component.self), c2)
            XCTAssertEqual(cells[3].component(as: A.Component.self), c3)
            XCTAssertEqual(cells[4].component(as: A.Component.self), c4)
            XCTAssertEqual(cells[5].component(as: A.Component.self), c5)
            XCTAssertEqual(cells[6].component(as: A.Component.self), c6)
            XCTAssertEqual(cells[7].component(as: A.Component.self), c7)
        }
    }

    func testInit9() {
        let c0 = A.Component(value: 0)
        let c1 = A.Component(value: 1)
        let c2 = A.Component(value: 2)
        let c3 = A.Component(value: 3)
        let c4 = A.Component(value: 4)
        let c5 = A.Component(value: 5)
        let c6 = A.Component(value: 6)
        let c7 = A.Component(value: 7)
        let c8 = A.Component(value: 8)
        let builders = [
            CellsBuilder(c0, c1, c2, c3, c4, c5, c6, c7, c8),
            CellsBuilder.buildBlock(c0, c1, c2, c3, c4, c5, c6, c7, c8)
        ]

        for builder in builders {
            let cells = builder.buildCells()

            XCTAssertEqual(cells.count, 9)
            XCTAssertEqual(cells[0].component(as: A.Component.self), c0)
            XCTAssertEqual(cells[1].component(as: A.Component.self), c1)
            XCTAssertEqual(cells[2].component(as: A.Component.self), c2)
            XCTAssertEqual(cells[3].component(as: A.Component.self), c3)
            XCTAssertEqual(cells[4].component(as: A.Component.self), c4)
            XCTAssertEqual(cells[5].component(as: A.Component.self), c5)
            XCTAssertEqual(cells[6].component(as: A.Component.self), c6)
            XCTAssertEqual(cells[7].component(as: A.Component.self), c7)
            XCTAssertEqual(cells[8].component(as: A.Component.self), c8)
        }
    }

    func testInit10() {
        let c0 = A.Component(value: 0)
        let c1 = A.Component(value: 1)
        let c2 = A.Component(value: 2)
        let c3 = A.Component(value: 3)
        let c4 = A.Component(value: 4)
        let c5 = A.Component(value: 5)
        let c6 = A.Component(value: 6)
        let c7 = A.Component(value: 7)
        let c8 = A.Component(value: 8)
        let c9 = A.Component(value: 9)
        let builders = [
            CellsBuilder(c0, c1, c2, c3, c4, c5, c6, c7, c8, c9),
            CellsBuilder.buildBlock(c0, c1, c2, c3, c4, c5, c6, c7, c8, c9)
        ]

        for builder in builders {
            let cells = builder.buildCells()

            XCTAssertEqual(cells.count, 10)
            XCTAssertEqual(cells[0].component(as: A.Component.self), c0)
            XCTAssertEqual(cells[1].component(as: A.Component.self), c1)
            XCTAssertEqual(cells[2].component(as: A.Component.self), c2)
            XCTAssertEqual(cells[3].component(as: A.Component.self), c3)
            XCTAssertEqual(cells[4].component(as: A.Component.self), c4)
            XCTAssertEqual(cells[5].component(as: A.Component.self), c5)
            XCTAssertEqual(cells[6].component(as: A.Component.self), c6)
            XCTAssertEqual(cells[7].component(as: A.Component.self), c7)
            XCTAssertEqual(cells[8].component(as: A.Component.self), c8)
            XCTAssertEqual(cells[9].component(as: A.Component.self), c9)
        }
    }
}

#endif
