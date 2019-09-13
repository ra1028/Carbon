#if swift(>=5.1)

import XCTest
@testable import Carbon

final class GroupTests: XCTestCase {
    func testInitWithoutElements() {
        let group = Group<CellNode>()
        XCTAssertTrue(group.elements.isEmpty)
    }

    func testCellsWithFunctionBuilder() {
        let componentA = A.Component()
        let componentB = B.Component()
        let componentA2 = A.Component()
        let componentB2 = B.Component()
        let appearsComponentB2 = false

        let group = Group {
            componentA
            componentB

            if true {
                componentA2
            }

            if appearsComponentB2 {
                componentB2
            }
        }

        let cells = group.buildCells()

        XCTAssertEqual(cells.count, 3)
        XCTAssertEqual(cells[0].component(as: A.Component.self), componentA)
        XCTAssertEqual(cells[1].component(as: B.Component.self), componentB)
        XCTAssertEqual(cells[2].component(as: A.Component.self), componentA2)
    }

    func testCellsWithSequence() {
        let range = 0..<3
        let group = Group(of: range) { value in
            A.Component(value: value)
        }

        let cells = group.buildCells()

        XCTAssertEqual(cells.count, 3)
        XCTAssertEqual(cells[0].component(as: A.Component.self)?.value, 0)
        XCTAssertEqual(cells[1].component(as: A.Component.self)?.value, 1)
        XCTAssertEqual(cells[2].component(as: A.Component.self)?.value, 2)
    }

    func testSectionsWithFunctionBuilder() {
        let section0 = Section(id: 0)
        let section1 = Section(id: 1)
        let section2 = Section(id: 2)
        let section3 = Section(id: 3)
        let appearsSection3 = false

        let group = Group {
            section0
            section1

            if true {
                section2
            }

            if appearsSection3 {
                section3
            }
        }

        let sections = group.buildSections()

        XCTAssertEqual(sections.count, 3)
        XCTAssertEqual(sections[0].id, 0)
        XCTAssertEqual(sections[1].id, 1)
        XCTAssertEqual(sections[2].id, 2)
    }

    func testSectionsWithSequence() {
        let range = 0..<3
        let group = Group(of: range) { value in
            Section(id: value)
        }

        let sections = group.buildSections()

        XCTAssertEqual(sections.count, 3)
        XCTAssertEqual(sections[0].id, 0)
        XCTAssertEqual(sections[1].id, 1)
        XCTAssertEqual(sections[2].id, 2)
    }
}

#endif
