import UIKit

/// The header or footer view as the container that renders the component.
open class UITableViewComponentHeaderFooterView: UITableViewHeaderFooterView, ComponentRenderable {
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
}
