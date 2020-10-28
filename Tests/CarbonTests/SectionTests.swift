import XCTest
@testable import Carbon

final class SectionTests: XCTestCase {
    func testInitWithFullParameters() {
        let section = Section(
            id: TestID.a,
            header: ViewNode(A.Component()),
            cells: [
                CellNode(MockIdentifiableComponent(id: TestID.a)),
                CellNode(MockIdentifiableComponent(id: TestID.b)),
                CellNode(MockIdentifiableComponent(id: TestID.c))
            ],
            footer: ViewNode(A.Component())
        )

        XCTAssertEqual(section.id.base as? TestID, .a)
        XCTAssertNotNil(section.header)
        XCTAssertNotNil(section.footer)
        XCTAssertEqual(section.cells.count, 3)
    }

    func testInitWithCellCollectionContainingNil() {
        let section = Section(
            id: TestID.a,
            cells: [
                CellNode(MockIdentifiableComponent(id: TestID.a)),
                nil,
                CellNode(MockIdentifiableComponent(id: TestID.c))
            ]
        )

        XCTAssertEqual(section.cells.count, 2)
    }

    func testContentEquatableConformance() {
        let section1 = Section(
            id: TestID.a,
            header: ViewNode(MockComponent(shouldContentUpdate: false)),
            footer: ViewNode(MockComponent(shouldContentUpdate: false))
        )

        XCTAssertEqual(section1.isContentEqual(to: section1), true)

        let section2 = Section(
            id: TestID.a,
            header: ViewNode(MockComponent(shouldContentUpdate: false)),
            footer: ViewNode(MockComponent(shouldContentUpdate: true))
        )

        XCTAssertEqual(section2.isContentEqual(to: section2), false)

        let section3 = Section(
            id: TestID.a,
            header: ViewNode(MockComponent(shouldContentUpdate: false)),
            footer: nil
        )

        XCTAssertEqual(section3.isContentEqual(to: section1), false)

        let section4 = Section(
            id: TestID.a,
            header: nil,
            footer: ViewNode(MockComponent(shouldContentUpdate: false))
        )

        XCTAssertEqual(section4.isContentEqual(to: section1), false)

        let section5 = Section(
            id: TestID.a,
            header: nil,
            footer: nil
        )

        XCTAssertEqual(section5.isContentEqual(to: section5), true)
    }

    func testDifferentiableConformance() {
        let section1 = Section(id: TestID.a)
        let section2 = Section(id: TestID.b)

        XCTAssertEqual(section1.differenceIdentifier.base as? TestID, .a)
        XCTAssertEqual(section2.differenceIdentifier.base as? TestID, .b)
    }

    func testElements() {
        let section = Section(
            id: TestID.a,
            cells: [
                CellNode(MockIdentifiableComponent(id: TestID.a)),
                CellNode(MockIdentifiableComponent(id: TestID.b)),
                CellNode(MockIdentifiableComponent(id: TestID.c))
            ]
        )

        XCTAssertEqual(section.cells.count, section.elements.count)
    }

    func testReproducing() {
        let source = Section(
            id: TestID.a,
            header: ViewNode(A.Component()),
            cells: [
                CellNode(MockIdentifiableComponent(id: TestID.a)),
                CellNode(MockIdentifiableComponent(id: TestID.b)),
                CellNode(MockIdentifiableComponent(id: TestID.c))
            ],
            footer: ViewNode(A.Component())
        )

        let reproduced = Section(
            source: source,
            elements: [
                CellNode(MockIdentifiableComponent(id: TestID.a)),
                CellNode(MockIdentifiableComponent(id: TestID.b))
            ]
        )

        XCTAssertEqual(reproduced.id, source.id)
        XCTAssertTrue(reproduced.header.isContentEqual(to: source.header))
        XCTAssertTrue(reproduced.footer.isContentEqual(to: source.footer))
        XCTAssertEqual(reproduced.cells.count, 2)
    }

    func testAvoidRedundantAnyHashableWrappingForID() {
        let dummyNode = CellNode(MockIdentifiableComponent(id: TestID.a))

        let section1 = Section(id: AnyHashable(TestID.a), cells: [dummyNode])
        XCTAssertEqual(section1.id, TestID.a)

        let section2 = Section(id: AnyHashable(TestID.b), cells: [dummyNode, nil])
        XCTAssertEqual(section2.id, TestID.b)
    }
}
