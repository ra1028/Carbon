import UIKit
import Carbon

final class HelloViewController: UIViewController {
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
        renderer.render {
            Header("GREET")
                .identified(by: \.title)

            if isToggled {
                HelloMessage("Jules")
                HelloMessage("Vincent")
            }
            else {
                HelloMessage("Vincent")
                HelloMessage("Jules")
                HelloMessage("Mia")
            }

            Footer("👋 Greeting from Carbon")
                .identified(by: \.text)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        isToggled.toggle()
    }
}
