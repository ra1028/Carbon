import UIKit

/// Represents the content of the `UITableViewHeaderFooterView`.
/// The content rendering the component does not always required to 
/// conform to this.
/// Make content conform to this protocol when you want to receive
/// `UITableViewHeaderFooterView`-specific behavior.
public protocol UITableViewHeaderFooterViewContent {
    /// Called after the `self` is rendered on specified view.
    ///
    /// - Parameter:
    ///   - view: An instance of view rendering `self`.
    func didRender(in view: UITableViewHeaderFooterView)

    /// Called after the component is rendered in `self` on the specified view.
    ///
    /// - Parameter:
    ///   - view: An instance of view rendering `self`.
    func didRenderComponent(in view: UITableViewHeaderFooterView)

    /// Called just before the view is dequeued.
    ///
    /// - Parameter:
    ///   - view: An instance of view rendering `self`.
    func viwDidPrepareForReuse(_ view: UITableViewHeaderFooterView)
}

public extension UITableViewHeaderFooterViewContent {
    /// Called after the `self` is rendered on specified view.
    ///
    /// - Parameter:
    ///   - view: An instance of view rendering `self`.
    func didRender(in view: UITableViewHeaderFooterView) {}

    /// Called after the component is rendered in `self` on the specified view.
    ///
    /// - Parameter:
    ///   - view: An instance of view rendering `self`.
    func didRenderComponent(in view: UITableViewHeaderFooterView) {}

    /// Called just before the view is dequeued.
    ///
    /// - Parameter:
    ///   - view: An instance of view rendering `self`.
    func viwDidPrepareForReuse(_ view: UITableViewHeaderFooterView) {}
}
