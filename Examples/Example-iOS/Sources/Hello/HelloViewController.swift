import UIKit
import Carbon

final class HelloViewController: UIViewController {
    enum ID {
        case greet
    }

    @IBOutlet var tableView: UITableView!

    var isToggled = false {
        didSet { render() }
    }

    private let renderer = Renderer(
        adapter: UITableViewAdapter(),
        updater: UITableViewUpdater()
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Hello"
        tableView.contentInset.top = 44
        renderer.target = tableView

        render()
    }

    func render() {
        renderer.render(
            Section(id: ID.greet) { section in
                section.header = ViewNode(Header(title: "GREET"))

                if isToggled {
                    section.cells = [
                        CellNode(HelloMessage(name: "Jules")),
                        CellNode(HelloMessage(name: "Vincent"))
                    ]
                }
                else {
                    section.cells = [
                        CellNode(HelloMessage(name: "Vincent")),
                        CellNode(HelloMessage(name: "Jules")),
                        CellNode(HelloMessage(name: "Butch"))
                    ]
                }

                section.footer = ViewNode(Footer(text: "💡 Tap anywhere"))
            }
        )
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        isToggled.toggle()
    }
}
