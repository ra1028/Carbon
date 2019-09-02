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
            Header(title: "GREET")
                .identified(by: \.title)

            if isToggled {
                HelloMessage(name: "Jules")
                HelloMessage(name: "Vincent")
            }
            else {
                HelloMessage(name: "Vincent")
                HelloMessage(name: "Jules")
                HelloMessage(name: "Butch")
            }

            Footer(text: "Tap anywhere 💡")
                .identified(by: \.text)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        isToggled.toggle()
    }
}
