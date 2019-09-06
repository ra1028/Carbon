import UIKit
import Carbon

final class EmojiViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var toolBar: UIToolbar!

    private let renderer = Renderer(
        adapter: UICollectionViewFlowLayoutAdapter(),
        updater: UICollectionViewUpdater()
    )

    var emojiCodes: [Int] = [] {
        didSet { render() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Shuffle Emoji"
        collectionView.contentInset.top = 44

        renderer.target = collectionView

        refresh()
    }

    func render() {
        renderer.render {
            Group(of: emojiCodes.enumerated()) { offset, code in
                EmojiLabel(code: code) { [weak self] in
                    self?.emojiCodes.remove(at: offset)
                }
            }
        }
    }

    @IBAction func refresh() {
        emojiCodes = Array(0x1F600...0x1F647)
    }

    @IBAction func shuffle() {
        emojiCodes.shuffle()
    }
}
