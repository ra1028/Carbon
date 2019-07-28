import UIKit
import Carbon
import MagazineLayout

final class KyotoViewController: UIViewController {
    enum ID {
        case top
        case photo
    }

    @IBOutlet var collectionView: UICollectionView!

    private let renderer = Renderer(
        adapter: MagazineLayoutKyotoAdapter(),
        updater: UICollectionViewUpdater()
    )

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.performBatchUpdates(nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Kyoto"

        let layout = MagazineLayout()
        collectionView.collectionViewLayout = layout

        renderer.target = collectionView
        renderer.render(
            Section(
                id: ID.top,
                header: ViewNode(KyotoTop())
            ),
            Section(
                id: ID.photo,
                header: ViewNode(Header(title: "PHOTOS")),
                cells: [
                    CellNode(KyotoImage(title: "Fushimi Inari-taisha", image: #imageLiteral(resourceName: "KyotoFushimiInari"))),
                    CellNode(KyotoImage(title: "Arashiyama", image: #imageLiteral(resourceName: "KyotoArashiyama"))),
                    CellNode(KyotoImage(title: "Byōdō-in", image: #imageLiteral(resourceName: "KyotoByōdōIn"))),
                    CellNode(KyotoImage(title: "Gion", image: #imageLiteral(resourceName: "KyotoGion"))),
                    CellNode(KyotoImage(title: "Kiyomizu-dera", image: #imageLiteral(resourceName: "KyotoKiyomizuDera")))
                ],
                footer: ViewNode(KyotoLicense {
                    let url = URL(string: "https://unsplash.com/")!
                    UIApplication.shared.open(url)
                })
            )
        )
    }
}

extension MagazineLayoutCollectionViewCell: ComponentRenderable {}

final class MagazineLayoutKyotoAdapter: UICollectionViewAdapter, UICollectionViewDelegateMagazineLayout {
    override func cellRegistration(collectionView: UICollectionView, indexPath: IndexPath, node: CellNode) -> CellRegistration {
        return CellRegistration(class: MagazineLayoutCollectionViewCell.self)
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
        return MagazineLayoutItemSizeMode(widthMode: .halfWidth, heightMode: .static(height: 150))
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
        return .hidden
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, horizontalSpacingForItemsInSectionAtIndex index: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, verticalSpacingForElementsInSectionAtIndex index: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsForSectionAtIndex index: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsForItemsInSectionAtIndex index: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
