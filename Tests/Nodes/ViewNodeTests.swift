import XCTest
@testable import Carbon

final class ViewNodeTests: XCTestCase {
    func testInitWithComponent() {
        let component = A.Component()
        let node = ViewNode(component)

        XCTAssertEqual(node.component.as(A.Component.self), component)
    }

    func testComponentCasting() {
        let component = A.Component()
        let node = ViewNode(component)

        XCTAssertNil(node.component(as: Never.self))
        XCTAssertNotNil(node.component(as: A.Component.self))
    }

    func testContentEquatableConformance() {
        let component1 = MockComponent(shouldContentUpdate: true)
        let component2 = MockComponent(shouldContentUpdate: false)
        let node1 = ViewNode(component1)
        let node2 = ViewNode(component2)

        XCTAssertEqual(node1.isContentEqual(to: node1), false)
        XCTAssertEqual(node2.isContentEqual(to: node2), true)
    }
}
