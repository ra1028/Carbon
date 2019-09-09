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
        adapter: KyotoMagazineLayoutAdapter(),
        updater: UICollectionViewUpdater()
    )

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Kyoto"

        let layout = MagazineLayout()
        collectionView.collectionViewLayout = layout
        renderer.target = collectionView

        renderer.render {
            Section(
                id: ID.top,
                header: KyotoTop()
            )

            Section(
                id: ID.photo,
                header: Header("PHOTOS"),
                footer: KyotoLicense {
                    let url = URL(string: "https://unsplash.com/")!
                    UIApplication.shared.open(url)
                },
                cells: {
                    KyotoImage(title: "Fushimi Inari-taisha", image: #imageLiteral(resourceName: "KyotoFushimiInari"))
                    KyotoImage(title: "Arashiyama", image: #imageLiteral(resourceName: "KyotoArashiyama"))
                    KyotoImage(title: "Byōdō-in", image: #imageLiteral(resourceName: "KyotoByōdōIn"))
                    KyotoImage(title: "Gion", image: #imageLiteral(resourceName: "KyotoGion"))
                    KyotoImage(title: "Kiyomizu-dera", image: #imageLiteral(resourceName: "KyotoKiyomizuDera"))
            })
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.performBatchUpdates(nil)
    }
}
