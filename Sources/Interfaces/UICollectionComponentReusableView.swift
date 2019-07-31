import UIKit

/// The header or footer view as the container that renders the component.
open class UICollectionComponentReusableView: UICollectionReusableView, ComponentRenderable {
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Create a new view with identifier for reuse.
    public override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
    }
}
