import UIKit

/// The cell as the container that renders the component.
open class UICollectionViewComponentCell: UICollectionViewCell, ComponentRenderable {
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
}
