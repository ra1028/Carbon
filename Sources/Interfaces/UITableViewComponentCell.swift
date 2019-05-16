import UIKit

/// The cell as the container that renders the component.
open class UITableViewComponentCell: UITableViewCell, ComponentRenderable {
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
}
