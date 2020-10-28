import UIKit

/// The cell as the container that renders the component.
open class UICollectionViewComponentCell: UICollectionViewCell, ComponentContainer {
    /// A content that rendered on the cell.
    open internal(set) var renderedContent: Any?

    /// A component that latest rendered in the content.
    open internal(set) var renderedComponent: AnyComponent?

    internal var containerView: UIView {
        return contentView
    }

    /// A Bool value indicating whether cell is highlighted.
    open override var isHighlighted: Bool {
        didSet {
            renderedCellContent?.cellDidSetHighlighted(self, isHighlighted: isHighlighted)
        }
    }

    /// A Bool value indicating whether cell is selected.
    open override var isSelected: Bool {
        didSet {
            renderedCellContent?.cellDidSetSelected(self, isSelected: isHighlighted)
        }
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Create a new cell with the frame.
    public override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    /// Called just before the cell is dequeued.
    open override func prepareForReuse() {
        super.prepareForReuse()

        renderedCellContent?.cellDidPrepareForReuse(self)
    }

    /// Called after the content is rendered on `self`.
    open func didRenderContent(_ content: Any) {
        renderedCellContent?.didRender(in: self)
    }

    /// Called after the component is rendered in the content.
    open func didRenderComponent(_ component: AnyComponent) {
        renderedCellContent?.didRenderComponent(in: self)
    }
}

private extension UICollectionViewComponentCell {
    var renderedCellContent: UICollectionViewCellContent? {
        return renderedContent as? UICollectionViewCellContent
    }
}
