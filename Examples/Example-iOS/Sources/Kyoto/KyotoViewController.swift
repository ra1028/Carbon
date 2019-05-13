import UIKit
import Carbon

final class KyotoViewController: UIViewController {
    enum ID {
        case top
        case photo
    }

    @IBOutlet var collectionView: UICollectionView!

    private let renderer = Renderer(
        adapter: UICollectionViewFlowLayoutAdapter(),
        updater: UICollectionViewUpdater()
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Kyoto"
        collectionView.contentInset.bottom = 24

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
