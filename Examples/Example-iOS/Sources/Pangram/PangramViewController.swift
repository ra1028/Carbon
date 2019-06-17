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
        toolBar.isTranslucent = false
        collectionView.contentInset.top = 44
        renderer.target = collectionView

        render()
    }

    func render() {
        if isSorted {

                "ABC DEF GHI JKL MNO PQR STU VWY XZ".split(separator: " ").enumerated().map { offset, word in
                    Section(
                        id: offset,
                        cells: word.map { text in
                            CellNode(PangramLabel(text: String(text)))
                        }
                    )
                }
            )
        }
        else {
            renderer.render(
                "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG".split(separator: " ").enumerated().map { offset, word in
                    Section(
                        id: offset,
                        cells: word.map { text in
                            CellNode(PangramLabel(text: String(text)))
                        }
                    )
                }
            )
        }
    }

    @IBAction func toggle() {
        isSorted.toggle()
    }
}
