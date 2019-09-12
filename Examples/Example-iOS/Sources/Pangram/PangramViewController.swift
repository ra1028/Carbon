import UIKit
import Carbon

final class PangramViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var toolBar: UIToolbar!

    private let renderer = Renderer(
        adapter: UICollectionViewFlowLayoutAdapter(),
        updater: UICollectionViewUpdater()
    )

    var isSorted = true {
        didSet { render() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Pangram"
        collectionView.contentInset.top = 44
        renderer.target = collectionView

        render()
    }

    func render() {
        let pangram = isSorted
            ? ["ABC", "DEF", "GHI", "JKL", "MNO", "PQR", "STU", "VWY", "XZ"]
            : ["THE", "QUICK", "BROWN", "FOX", "JUMPS", "OVER", "THE", "LAZY", "DOG"]

        renderer.render {
            Group(of: pangram.enumerated()) { offset, word in
                Section(id: offset) {
                    Group(of: word) { text in
                        PangramLabel(text: String(text))
                    }
                }
            }
        }
    }

    @IBAction func toggle() {
        isSorted.toggle()
    }
}
