import UIKit

/// An adapter for `UICollectionView` with `UICollectionViewFlowLayout` inherited from `UICollectionViewAdapter`.
open class UICollectionViewFlowLayoutAdapter: UICollectionViewAdapter {}

extension UICollectionViewFlowLayoutAdapter: UICollectionViewDelegateFlowLayout {
    /// Returns the size for item at specified index path.
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let node = cellNode(at: indexPath)
        return node.component.referenceSize(in: collectionView.bounds) ?? collectionViewLayout.flowLayout?.itemSize ?? .zero
    }

    /// Returns the size for header in specified section.
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let node = headerNode(in: section) else {
            return .zero
        }

        return node.component.referenceSize(in: collectionView.bounds) ?? collectionViewLayout.flowLayout?.headerReferenceSize ?? .zero
    }

    /// Returns the size for footer in specified section.
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let node = footerNode(in: section) else {
            return .zero
        }

        return node.component.referenceSize(in: collectionView.bounds) ?? collectionViewLayout.flowLayout?.footerReferenceSize ?? .zero
    }
}

private extension UICollectionViewLayout {
    var flowLayout: UICollectionViewFlowLayout? {
        return self as? UICollectionViewFlowLayout
    }
}
