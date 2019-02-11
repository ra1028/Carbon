import XCTest
@testable import Carbon

final class ComponentContainerTests: XCTestCase {
    func testContentWillDisplay() {
        let container = MockComponentContainer()
        let component = MockComponent()
        let content = UIView()

        container.renderedComponent = AnyComponent(component)
        container.renderedContent = content
        container.contentWillDisplay()

        if let captured = component.contentCapturedOnWillDisplay {
            XCTAssertEqual(captured, content)
        }
        else {
            XCTFail()
        }
    }

    func testContentDidEndDisplay() {
        let container = MockComponentContainer()
        let component = MockComponent()
        let content = UIView()

        container.renderedComponent = AnyComponent(component)
        container.renderedContent = content
        container.contentDidEndDisplay()

        if let captured = component.contentCapturedOnDidEndDisplay {
            XCTAssertEqual(captured, content)
        }
        else {
            XCTFail()
        }
    }

    func testRenderComponent() {
        let component = MockComponent(shouldRender: false)
        let containerView = UIView()
        let container = MockComponentContainer(containerView: containerView)

        container.render(component: AnyComponent(component))

        if
            let subview = containerView.subviews.first,
            let renderedContent = container.renderedContent as? UIView?,
            let renderedComponent = container.renderedComponent?.as(MockComponent.self),
            let capturedContentInComponent = component.contentCapturedOnRender,
            let capturedContentInContainer = container.contentCapturedOnDidRender as? UIView,
            let capturedComponentInContainer = container.componentCapturedOnDidRender?.as(MockComponent.self) {
            XCTAssertEqual(renderedContent, subview)
            XCTAssertEqual(capturedContentInComponent, renderedContent)
            XCTAssertEqual(renderedComponent, component)
            XCTAssertEqual(capturedContentInContainer, subview)
            XCTAssertEqual(capturedComponentInContainer, component)
        }
        else {
            XCTFail()
        }
    }

    func testShouldRenderComponent() {
        let component = A.Component(value: 100)
        let content = A.Content()
        let container = MockComponentContainer()

        container.renderedComponent = AnyComponent(component)
        container.renderedContent = content

        let nextComponent = A.Component(value: 200)

        container.render(component: AnyComponent(nextComponent))

        if let renderedComponent = container.renderedComponent?.as(A.Component.self) {
            XCTAssertEqual(renderedComponent.value, 100)
        }
        else {
            XCTFail()
        }
    }
}
