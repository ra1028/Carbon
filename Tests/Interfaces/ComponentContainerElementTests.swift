import XCTest
@testable import Carbon

final class ComponentContainerTests: XCTestCase {
    func testContentWillDisplay() {
        let container = MockComponentContainer()
        let content = UIView()
        let component = MockComponent(content: content)

        container.render(component: AnyComponent(component))
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
        let content = UIView()
        let component = MockComponent(content: content)

        container.render(component: AnyComponent(component))
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
        let componentContainerView = UIView()
        let container = MockComponentContainer(componentContainerView: componentContainerView)

        container.render(component: AnyComponent(component))

        XCTAssertEqual(component.contentCapturedOnLayout, container.renderedContent as? UIView?)
        XCTAssertEqual(component.contentCapturedOnRender, container.renderedContent as? UIView?)
        XCTAssertEqual(component, container.renderedComponent?.as(MockComponent.self))
    }

    func testShouldRenderComponent() {
        let component = A.Component(value: 100)
        let container = MockComponentContainer()

        container.render(component: AnyComponent(component))

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
