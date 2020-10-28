import UIKit

/// Represents the content of the `UICollectionViewCell`.
/// The content rendering the component does not always required to 
/// conform to this.
/// Make content conform to this protocol when you want to receive
/// `UICollectionViewCell`-specific behavior.
public protocol UICollectionViewCellContent {
    /// Called after the `self` is rendered on specified cell.
    ///
    /// - Parameter:
    ///   - cell: An instance of cell rendering `self`.
    func didRender(in cell: UICollectionViewCell)

    /// Called after the component is rendered in `self` on the specified cell.
    ///
    /// - Parameter:
    ///   - cell: An instance of cell rendering `self`.
    func didRenderComponent(in cell: UICollectionViewCell)

    /// Called just before the cell is dequeued.
    ///
    /// - Parameter:
    ///   - cell: An instance of cell rendering `self`.
    func cellDidPrepareForReuse(_ cell: UICollectionViewCell)

    /// Called when the cell is highlighted.
    ///
    /// - Parameters:
    ///   - cell: An instance of cell rendering `self`.
    ///   - isHighlighted: A Bool value indicating whether the cell is highlighted.
    func cellDidSetHighlighted(_ cell: UICollectionViewCell, isHighlighted: Bool)

    /// Called when the cell is selected.
    ///
    /// - Parameters:
    ///   - cell: An instance of cell rendering `self`.
    ///   - isHighlighted: A Bool value indicating whether the cell is selected.
    func cellDidSetSelected(_ cell: UICollectionViewCell, isSelected: Bool)
}

public extension UICollectionViewCellContent {
    /// Called after the `self` is rendered on specified cell.
    ///
    /// - Parameter:
    ///   - cell: An instance of cell rendering `self`.
    func didRender(in cell: UICollectionViewCell) {}

    /// Called after the component is rendered in `self` on the specified cell.
    ///
    /// - Parameter:
    ///   - cell: An instance of cell rendering `self`.
    func didRenderComponent(in cell: UICollectionViewCell) {}

    /// Called just before the cell is dequeued.
    ///
    /// - Parameter:
    ///   - cell: An instance of cell rendering `self`.
    func cellDidPrepareForReuse(_ cell: UICollectionViewCell) {}

    /// Called when the cell is highlighted.
    ///
    /// - Parameters:
    ///   - cell: An instance of cell rendering `self`.
    ///   - isHighlighted: A Bool value indicating whether the cell is highlighted.
    func cellDidSetHighlighted(_ cell: UICollectionViewCell, isHighlighted: Bool) {}

    /// Called when the cell is selected.
    ///
    /// - Parameters:
    ///   - cell: An instance of cell rendering `self`.
    ///   - isHighlighted: A Bool value indicating whether the cell is selected.
    func cellDidSetSelected(_ cell: UICollectionViewCell, isSelected: Bool) {}
}
