import XCTest
@testable import Carbon

final class ComponentTests: XCTestCase {
    func testReuseIdentifier() {
        let componentA = A.Component()
        let componentB = B.Component()

        XCTAssertEqual(componentA.reuseIdentifier, "CarbonTests.A.Content")
        XCTAssertEqual(componentB.reuseIdentifier, "CarbonTests.B.Content")
        XCTAssertNotEqual(componentA.reuseIdentifier, componentB.reuseIdentifier)
    }

    func testLayout() {
        let component = A.Component()
        let content = component.renderContent()
        let frame = CGRect(x: 0, y: 0, width: 200, height: 300)
        let container = UIView(frame: frame)

        component.layout(content: content, in: container)
        container.layoutIfNeeded()
        XCTAssertEqual(content.frame, frame)
    }

    func testShouldContentUpdateWhenEquatable() {
        let component1 = A.Component(value: 100)
        let component2 = A.Component(value: 200)

        XCTAssertFalse(component1.shouldContentUpdate(with: component1))
        XCTAssertTrue(component1.shouldContentUpdate(with: component2))
    }
}
