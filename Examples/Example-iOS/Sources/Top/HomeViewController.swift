import UIKit
import Carbon

final class HomeViewController: UIViewController {
    enum ID {
        case examples
    }

    enum Destination {
        case hello
        case pangram
        case kyoto
        case emoji
        case todo
        case form
    }

    @IBOutlet var tableView: UITableView!

    private lazy var renderer = Renderer(
        target: tableView,
        adapter: UITableViewAdapter(),
        updater: UITableViewUpdater()
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"

        renderer.render(
            Section(
                id: ID.examples,
                header: ViewNode(Header(title: "EXAMPLES")),
                cells: [
                    CellNode(HomeItem(title: "👋 Hello") { [weak self] in
                        self?.push(to: .hello)
                    }),
                    CellNode(HomeItem(title: "🔠 Pangram") { [weak self] in
                        self?.push(to: .pangram)
                    }),
                    CellNode(HomeItem(title: "⛩ Kyoto") { [weak self] in
                        self?.push(to: .kyoto)
                    }),
                    CellNode(HomeItem(title: "😀 Shuffle Emoji") { [weak self] in
                        self?.push(to: .emoji)
                    }),
                    CellNode(HomeItem(title: "📋 Todo App") { [weak self] in
                        self?.push(to: .todo)
                    }),
                    CellNode(HomeItem(title: "👤 Profile Form") { [weak self] in
                        self?.push(to: .form)
                    })
                ]
            )
        )
    }

    func push(to destination: Destination) {
        let controller: UIViewController

        switch destination {
        case .hello:
            controller = HelloViewController()

        case .pangram:
            controller = PangramViewController()

        case .kyoto:
            controller = KyotoViewController()

        case .emoji:
            controller = EmojiViewController()

        case .todo:
            controller = TodoViewController()

        case .form:
            controller = FormViewController()
        }

        navigationController?.pushViewController(controller, animated: true)
    }
}
