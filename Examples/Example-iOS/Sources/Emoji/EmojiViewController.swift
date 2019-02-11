import UIKit
import Carbon

final class EmojiViewController: UIViewController {
    enum ID {
        case emoji
    }

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var toolBar: UIToolbar!

    private lazy var renderer = Renderer(
        target: collectionView,
        adapter: UICollectionViewFlowLayoutAdapter(),
        updater: UICollectionViewUpdater()
    )

    var emojiCodes: [Int] = [] {
        didSet { render() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Shuffle Emoji"
        toolBar.isTranslucent = false
        collectionView.contentInset.bottom = 44
        renderer.updater.alwaysRenderVisibleComponents = true

        refresh()
    }

    func render() {
        renderer.render(
            Section(
                id: ID.emoji,
                header: ViewNode(Header(title: "EMOJIS")),
                cells: emojiCodes.enumerated().map { offset, code in
                    CellNode(EmojiLabel(code: code) { [weak self] in
                        self?.emojiCodes.remove(at: offset)
                    })
                }
            )
        )
    }

    @IBAction func refresh() {
        emojiCodes = Array(0x1F600...0x1F647)
    }

    @IBAction func shuffle() {
        emojiCodes.shuffle()
    }
}
