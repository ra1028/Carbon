import UIKit

public protocol ComponentRenderable: class {
    var componentContainerView: UIView { get }
}

private let renderedContentAssociation = RuntimeAssociation<Any?>(default: nil)
private let renderedComponentAssociation = RuntimeAssociation<AnyComponent?>(default: nil)

public extension ComponentRenderable {
    private(set) var renderedContent: Any? {
        get { return renderedContentAssociation[self] }
        set { renderedContentAssociation[self] = newValue }
    }

    private(set) var renderedComponent: AnyComponent? {
        get { return renderedComponentAssociation[self] }
        set { renderedComponentAssociation[self] = newValue }
    }

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

        case (nil, _):
            let content = component.renderContent()
            component.layout(content: content, in: componentContainerView)
            renderedContent = content
            render(component: component)
        }
    }
}

public extension ComponentRenderable where Self: UITableViewCell {
    var componentContainerView: UIView {
        return contentView
    }
}

public extension ComponentRenderable where Self: UITableViewHeaderFooterView {
    var componentContainerView: UIView {
        return contentView
    }
}

public extension ComponentRenderable where Self: UICollectionViewCell {
    var componentContainerView: UIView {
        return contentView
    }
}

public extension ComponentRenderable where Self: UICollectionReusableView {
    var componentContainerView: UIView {
        return self
    }
}
