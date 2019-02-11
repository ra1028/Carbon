import XCTest
@testable import Carbon

final class AnyComponentTests: XCTestCase {
    func testBase() {
        let component = A.Component()
        let anyComponent = AnyComponent(component)

        XCTAssertEqual(component, anyComponent.as(A.Component.self))
    }

    func testRedundantWrapping() {
        let component = A.Component()
        let anyComponent1 = AnyComponent(component)
        let anyComponent2 = AnyComponent(anyComponent1)

        XCTAssertEqual(anyComponent1.as(A.Component.self), component)
        XCTAssertEqual(anyComponent2.as(A.Component.self), component)
        XCTAssertEqual(anyComponent1.as(A.Component.self), anyComponent2.as(A.Component.self))
    }

    func testReuseIdentifier() {
        let component = A.Component()
        let anyComponent = AnyComponent(component)

        XCTAssertEqual(component.reuseIdentifier, anyComponent.reuseIdentifier)
    }

    func testRenderContent() {
        let component = A.Component()
        let anyComponent = AnyComponent(component)
        let anyContent = anyComponent.renderContent()

        XCTAssertTrue(anyContent is A.Component.Content)
    }

    func testRenderInContent() {
        let component = MockComponent()
        let anyComponent = AnyComponent(component)
        let anyContent = anyComponent.renderContent()

        anyComponent.render(in: anyContent)

        let expectedContent = anyContent as? MockComponent.Content
        XCTAssertEqual(component.contentCapturedOnRender, expectedContent)
    }

    func testReferenceSize() {
        let expectedSize = CGSize(width: 100, height: 200)
        let component = MockComponent(referenceSize: expectedSize)
        let anyComponent = AnyComponent(component)

        XCTAssertEqual(component.referenceSize(in: .zero), anyComponent.referenceSize(in: .zero))
        XCTAssertEqual(anyComponent.referenceSize(in: .zero), expectedSize)
    }

    func testLayout() {
        let component = MockComponent()
        let anyComponent = AnyComponent(component)
        let anyContent = anyComponent.renderContent()
        let frame = CGRect(x: 0, y: 0, width: 200, height: 300)
        let container = UIView(frame: frame)

        anyComponent.layout(content: anyContent, in: container)
        container.layoutIfNeeded()
        XCTAssertEqual((anyContent as? MockComponent.Content)?.frame, frame)
    }

    func testShouldContentUpdate() {
        let component1 = MockComponent(shouldContentUpdate: true)
        let component2 = MockComponent(shouldContentUpdate: false)
        let anyComponent1 = AnyComponent(component1)
        let anyComponent2 = AnyComponent(component2)

        XCTAssertEqual(anyComponent1.shouldContentUpdate(with: anyComponent1), true)
        XCTAssertEqual(anyComponent2.shouldContentUpdate(with: anyComponent2), false)
    }

    func testShouldRender() {
        let component1 = MockComponent(shouldRender: true)
        let component2 = MockComponent(shouldRender: false)
        let anyComponent1 = AnyComponent(component1)
        let anyComponent2 = AnyComponent(component2)

        let dummyContent = component1.renderContent()

        XCTAssertEqual(anyComponent1.shouldRender(next: anyComponent1, in: dummyContent), true)
        XCTAssertEqual(anyComponent2.shouldRender(next: anyComponent2, in: dummyContent), false)
    }

    func testContentWillDisplay() {
        let component = MockComponent()
        let content = component.renderContent()
        let anyComponent = AnyComponent(component)

        anyComponent.contentWillDisplay(content)

        XCTAssertEqual(component.contentCapturedOnWillDisplay, content)
    }

    func testContentDidEndDisplay() {
        let component = MockComponent()
        let content = component.renderContent()
        let anyComponent = AnyComponent(component)

        anyComponent.contentDidEndDisplay(content)

        XCTAssertEqual(component.contentCapturedOnDidEndDisplay, content)
    }
}
