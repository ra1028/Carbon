import XCTest
@testable import Carbon

final class CellNodeTests: XCTestCase {
    func testInitWithComponent() {
        let component = A.Component()
        let node = CellNode(id: TestID.a, component)

        XCTAssertEqual(node.id.base as? TestID, .a)
        XCTAssertEqual(node.component.as(A.Component.self), component)
    }

    func testInitWithIdentifiableComponent() {
        let component = MockIdentifiableComponent(id: TestID.a)
        let node = CellNode(component)

        XCTAssertEqual(node.id.base as? TestID, .a)
        XCTAssertEqual(node.component.as(MockIdentifiableComponent<TestID>.self), component)
    }

    func testComponentCasting() {
        let component = A.Component()
        let node = CellNode(id: TestID.a, component)

        XCTAssertNil(node.component(as: Never.self))
        XCTAssertNotNil(node.component(as: A.Component.self))
    }

    func testContentEquatableConformance() {
        let component1 = MockComponent(shouldContentUpdate: true)
        let component2 = MockComponent(shouldContentUpdate: false)
        let node1 = CellNode(id: TestID.a, component1)
        let node2 = CellNode(id: TestID.b, component2)

        XCTAssertEqual(node1.isContentEqual(to: node1), false)
        XCTAssertEqual(node2.isContentEqual(to: node2), true)
    }

    func testDifferentiableConformance() {
        let component1 = MockComponent()
        let component2 = MockIdentifiableComponent(id: TestID.b)
        let node1 = CellNode(id: TestID.a, component1)
        let node2 = CellNode(component2)
        let node3 = CellNode(id: TestID.c, component2)

        XCTAssertEqual(node1.differenceIdentifier.base as? TestID, .a)
        XCTAssertEqual(node2.differenceIdentifier.base as? TestID, .b)
        XCTAssertEqual(node3.differenceIdentifier.base as? TestID, .c)
    }

    func testAvoidRedundantAnyHashableWrappingForID() {
        let component = MockIdentifiableComponent(id: AnyHashable(TestID.a))
        let node1 = CellNode(component)
        let node2 = CellNode(id: AnyHashable(TestID.b), component)

        XCTAssertEqual(node1.id, component.id)
        XCTAssertEqual(node2.id, TestID.b)
    }
}
