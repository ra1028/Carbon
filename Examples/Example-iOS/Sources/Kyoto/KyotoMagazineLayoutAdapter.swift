import UIKit
import Carbon
import MagazineLayout

extension MagazineLayoutCollectionViewCell: ComponentRenderable {}

final class KyotoMagazineLayoutAdapter: UICollectionViewAdapter, UICollectionViewDelegateMagazineLayout {
    override func cellRegistration(collectionView: UICollectionView, indexPath: IndexPath, node: CellNode) -> CellRegistration {
        CellRegistration(class: MagazineLayoutCollectionViewCell.self)
    }

    override func supplementaryViewNode(forElementKind kind: String, collectionView: UICollectionView, at indexPath: IndexPath) -> ViewNode? {
        switch kind {
        case MagazineLayout.SupplementaryViewKind.sectionHeader:
            return headerNode(in: indexPath.section)

        case MagazineLayout.SupplementaryViewKind.sectionFooter:
            return footerNode(in: indexPath.section)

        default:
            return super.supplementaryViewNode(forElementKind: kind, collectionView: collectionView, at: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeModeForItemAt indexPath: IndexPath) -> MagazineLayoutItemSizeMode {
        let node = cellNode(at: indexPath)
        guard let size = node.component.referenceSize(in: collectionView.bounds) else {
            return MagazineLayoutItemSizeMode(widthMode: .halfWidth, heightMode: .dynamic)
        }

        return MagazineLayoutItemSizeMode(widthMode: .halfWidth, heightMode: .static(height: size.height))
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        visibilityModeForHeaderInSectionAtIndex index: Int
        ) -> MagazineLayoutHeaderVisibilityMode {
        guard let node = headerNode(in: index) else {
            return .hidden
        }

        guard let referenceSize = node.component.referenceSize(in: collectionView.bounds) else {
            return .visible(heightMode: .dynamic)
        }

        return .visible(heightMode: .static(height: referenceSize.height))
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        visibilityModeForFooterInSectionAtIndex index: Int
        ) -> MagazineLayoutFooterVisibilityMode {
        guard let node = footerNode(in: index) else {
            return .hidden
        }

        guard let referenceSize = node.component.referenceSize(in: collectionView.bounds) else {
            return .visible(heightMode: .dynamic)
        }

        return .visible(heightMode: .static(height: referenceSize.height))
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        visibilityModeForBackgroundInSectionAtIndex index: Int
        ) -> MagazineLayoutBackgroundVisibilityMode {
        .hidden
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, horizontalSpacingForItemsInSectionAtIndex index: Int) -> CGFloat {
        16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, verticalSpacingForElementsInSectionAtIndex index: Int) -> CGFloat {
        16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsForSectionAtIndex index: Int) -> UIEdgeInsets {
        .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsForItemsInSectionAtIndex index: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
