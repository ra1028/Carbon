import UIKit

internal protocol ComponentContainer: class {
    var renderedContent: Any? { get set }
    var renderedComponent: AnyComponent? { get set }
    var containerView: UIView { get }

    func didRenderContent(_ content: Any)
    func didRenderComponent(_ component: AnyComponent)
}

internal extension ComponentContainer {
    func contentWillDisplay() {
        guard let content = renderedContent else { return }

        renderedComponent?.contentWillDisplay(content)
    }

    func contentDidEndDisplay() {
        guard let content = renderedContent else { return }

        renderedComponent?.contentDidEndDisplay(content)
    }

    func render(component: AnyComponent) {
        switch (renderedContent, renderedComponent) {
        case (let content?, let renderedComponent?) where !renderedComponent.shouldRender(next: component, in: content):
            break

        case (let content?, _):
            component.render(in: content)
            renderedComponent = component
            didRenderComponent(component)

        case (nil, _):
            let content = component.renderContent()
            component.layout(content: content, in: containerView)
            renderedContent = content
            didRenderContent(content)
            render(component: component)
        }
    }
}
