import UIKit

/// Represents the content of the `UICollectionReusableView`.
/// The content rendering the component does not always required to 
/// conform to this.
/// Make content conform to this protocol when you want to receive
/// `UICollectionReusableView`-specific behavior.
public protocol UICollectionReusableViewContent {
    /// Called after the `self` is rendered on specified view.
    ///
    /// - Parameter:
    ///   - view: An instance of view rendering `self`.
    func didRender(in view: UICollectionReusableView)

    /// Called after the component is rendered in `self` on the specified view.
    ///
    /// - Parameter:
    ///   - view: An instance of view rendering `self`.
    func didRenderComponent(in view: UICollectionReusableView)

    /// Called just before the view is dequeued.
    ///
    /// - Parameter:
    ///   - view: An instance of view rendering `self`.
    func viewDidPrepareForReuse(_ view: UICollectionReusableView)
}

public extension UICollectionReusableViewContent {
    /// Called after the `self` is rendered on specified view.
    ///
    /// - Parameter:
    ///   - view: An instance of view rendering `self`.
    func didRender(in view: UICollectionReusableView) {}

    /// Called after the component is rendered in `self` on the specified view.
    ///
    /// - Parameter:
    ///   - view: An instance of view rendering `self`.
    func didRenderComponent(in view: UICollectionReusableView) {}

    /// Called just before the view is dequeued.
    ///
    /// - Parameter:
    ///   - view: An instance of view rendering `self`.
    func viewDidPrepareForReuse(_ view: UICollectionReusableView) {}
}
