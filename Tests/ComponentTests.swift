import XCTest
@testable import Carbon

final class ComponentTests: XCTestCase {
    func testReuseIdentifier() {
        let componentA = A.Component()
        let componentB = B.Component()

        XCTAssertEqual(componentA.reuseIdentifier, "Tests.A.Component")
        XCTAssertEqual(componentB.reuseIdentifier, "Tests.B.Component")
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

    func testIntrinsicContentSizeForView() {
        struct TestComponent: Component {
            func renderContent() -> UILabel {
                UILabel()
            }

            func render(in content: UILabel) {
                content.text = "Test"
            }
        }

        let component = TestComponent()
        let content = component.renderContent()
        component.render(in: content)

        XCTAssertEqual(component.intrinsicContentSize(for: content), content.intrinsicContentSize)
    }

    func testShouldContentUpdateWhenEquatable() {
        let component1 = A.Component(value: 100)
        let component2 = A.Component(value: 200)

        // Always false by default.
        XCTAssertFalse(component1.shouldContentUpdate(with: component1))
        XCTAssertFalse(component1.shouldContentUpdate(with: component2))
    }
}
