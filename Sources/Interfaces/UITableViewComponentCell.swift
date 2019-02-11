import UIKit

/// The cell as the container that renders the component.
open class UITableViewComponentCell: UITableViewCell, ComponentContainer {
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

    /// Create a new cell with style and identifier for reuse.
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
    }

    /// Called just before the cell is dequeued.
    open override func prepareForReuse() {
        super.prepareForReuse()

        renderedCellContent?.cellDidPrepareForReuse(self)
    }

    /// Called when the cell is highlighted.
    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        renderedCellContent?.cellDidSetHighlighted(self, isHighlighted: highlighted, animated: animated)
    }

    /// Called when the cell is selected.
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        renderedCellContent?.cellDidSetSelected(self, isSelected: selected, animated: animated)
    }

    /// Called when the cell become editing.
    open override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        renderedCellContent?.cellDidSetEditing(self, isEditing: editing, animated: animated)
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

private extension UITableViewComponentCell {
    var renderedCellContent: UITableViewCellContent? {
        return renderedContent as? UITableViewCellContent
    }
}
