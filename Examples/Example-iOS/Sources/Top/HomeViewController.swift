import UIKit
import Carbon

final class HomeViewController: UIViewController {
    enum Destination {
        case hello
        case pangram
        case kyoto
        case emoji
        case todo
        case form
    }

    @IBOutlet var tableView: UITableView!

    private let renderer = Renderer(
        adapter: UITableViewAdapter(),
        updater: UITableViewUpdater()
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"
        renderer.target = tableView

        renderer.render {
            Header(title: "EXAMPLES")
                .identified(by: \.title)

            HomeItem(title: "👋 Hello") { [weak self] in
                self?.push(.hello)
            }

            HomeItem(title: "🔠 Pangram") { [weak self] in
                self?.push(.pangram)
            }

            HomeItem(title: "⛩ Kyoto") { [weak self] in
                self?.push(.kyoto)
            }

            HomeItem(title: "😀 Shuffle Emoji") { [weak self] in
                self?.push(.emoji)
            }

            HomeItem(title: "📋 Todo App") { [weak self] in
                self?.push(.todo)
            }

            HomeItem(title: "👤 Profile Form") { [weak self] in
                self?.push(.form)
            }
        }
    }

    func push(_ destination: Destination) {
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
