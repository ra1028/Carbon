import UIKit

/// Represents the content of the `UITableViewCell`.
/// The content rendering the component does not always required to 
/// conform to this.
/// Make content conform to this protocol when you want to receive
/// `UITableViewCell`-specific behavior.
public protocol UITableViewCellContent {
    /// Called after the `self` is rendered on specified cell.
    ///
    /// - Parameter:
    ///   - cell: An instance of cell rendering `self`.
    func didRender(in cell: UITableViewCell)

    /// Called after the component is rendered in `self` on the specified cell.
    ///
    /// - Parameter:
    ///   - cell: An instance of cell rendering `self`.
    func didRenderComponent(in cell: UITableViewCell)

    /// Called just before the cell is dequeued.
    ///
    /// - Parameter:
    ///   - cell: An instance of cell rendering `self`.
    func cellDidPrepareForReuse(_ cell: UITableViewCell)

    /// Called when the cell is highlighted.
    ///
    /// - Parameters:
    ///   - cell: An instance of cell rendering `self`.
    ///   - isHighlighted: A Bool value indicating whether the cell is highlighted.
    ///   - animated: A Bool value that indicating whether animation is required.
    func cellDidSetHighlighted(_ cell: UITableViewCell, isHighlighted: Bool, animated: Bool)

    /// Called when the cell is selected.
    ///
    /// - Parameters:
    ///   - cell: An instance of cell rendering `self`.
    ///   - isHighlighted: A Bool value indicating whether the cell is selected.
    ///   - animated: A Bool value that indicating whether animation is required.
    func cellDidSetSelected(_ cell: UITableViewCell, isSelected: Bool, animated: Bool)

    /// Called when the cell become editing.
    ///
    /// - Parameters:
    ///   - cell: An instance of cell rendering `self`.
    ///   - isHighlighted: A Bool value indicating whether the cell become editing.
    ///   - animated: A Bool value that indicating whether animation is required.
    func cellDidSetEditing(_ cell: UITableViewCell, isEditing: Bool, animated: Bool)
}

public extension UITableViewCellContent {
    /// Called after the `self` is rendered on specified cell.
    ///
    /// - Parameter:
    ///   - cell: An instance of cell rendering `self`.
    func didRender(in cell: UITableViewCell) {}

    /// Called after the component is rendered in `self` on the specified cell.
    ///
    /// - Parameter:
    ///   - cell: An instance of cell rendering `self`.
    func didRenderComponent(in cell: UITableViewCell) {}

    /// Called just before the cell is dequeued.
    ///
    /// - Parameter:
    ///   - cell: An instance of cell rendering `self`.
    func cellDidPrepareForReuse(_ cell: UITableViewCell) {}

    /// Called when the cell is highlighted.
    ///
    /// - Parameters:
    ///   - cell: An instance of cell rendering `self`.
    ///   - isHighlighted: A Bool value indicating whether the cell is highlighted.
    ///   - animated: A Bool value that indicating whether animation is required.
    func cellDidSetHighlighted(_ cell: UITableViewCell, isHighlighted: Bool, animated: Bool) {}

    /// Called when the cell is selected.
    ///
    /// - Parameters:
    ///   - cell: An instance of cell rendering `self`.
    ///   - isHighlighted: A Bool value indicating whether the cell is selected.
    ///   - animated: A Bool value that indicating whether animation is required.
    func cellDidSetSelected(_ cell: UITableViewCell, isSelected: Bool, animated: Bool) {}

    /// Called when the cell become editing.
    ///
    /// - Parameters:
    ///   - cell: An instance of cell rendering `self`.
    ///   - isHighlighted: A Bool value indicating whether the cell become editing.
    ///   - animated: A Bool value that indicating whether animation is required.
    func cellDidSetEditing(_ cell: UITableViewCell, isEditing: Bool, animated: Bool) {}
}
