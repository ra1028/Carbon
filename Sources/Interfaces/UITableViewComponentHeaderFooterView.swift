import UIKit

/// The header or footer view as the container that renders the component.
open class UITableViewComponentHeaderFooterView: UITableViewHeaderFooterView, ComponentContainer {
    /// A content that rendered on the cell.
    open internal(set) var renderedContent: Any?

    /// A component that latest rendered in the content.
    open internal(set) var renderedComponent: AnyComponent?

    internal var containerView: UIView {
        return contentView
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Create a new view with identifier for reuse.
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        backgroundView = UIView()
        contentView.backgroundColor = .clear
    }

    /// Called just before the cell is dequeued.
    open override func prepareForReuse() {
        super.prepareForReuse()

        renderedViewContent?.viwDidPrepareForReuse(self)
    }

    /// Called after the content is rendered on `self`.
    open func didRenderContent(_ content: Any) {
        renderedViewContent?.didRender(in: self)
    }

    /// Called after the component is rendered in the content.
    open func didRenderComponent(_ component: AnyComponent) {
        renderedViewContent?.didRenderComponent(in: self)
    }
}

private extension UITableViewComponentHeaderFooterView {
    var renderedViewContent: UITableViewHeaderFooterViewContent? {
        return renderedContent as? UITableViewHeaderFooterViewContent
    }
}
