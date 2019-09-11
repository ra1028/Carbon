/*:
 ## Welcome to `Carbon` Playground
 ----
 > 1. Open Carbon.xcworkspace.
 > 2. Build the Carbon.
 > 3. Open Carbon playground in project navigator.
 > 4. Show the live view in assistant editor.
 */
import Carbon
import UIKit
import PlaygroundSupport

// Setup

let frame = CGRect(x: 0, y: 0, width: 375, height: 812)
let tableView = UITableView(frame: frame, style: .grouped)
tableView.estimatedSectionHeaderHeight = 44
tableView.estimatedSectionFooterHeight = 44

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = tableView

// Define component

struct Label: Component {
    var text: String

    func renderContent() -> UILabel {
        return UILabel()
    }

    func render(in content: UILabel) {
        content.text = text
    }
}

// Create renderer

let renderer = Renderer(
    adapter: UITableViewAdapter(),
    updater: UITableViewUpdater()
)

renderer.target = tableView

// Render

renderer.render {
    Section(id: 0) {
        Label(text: "Cell 1").identified(by: \.text)
        Label(text: "Cell 2").identified(by: \.text)
        Label(text: "Cell 3").identified(by: \.text)
        Label(text: "Cell 4").identified(by: \.text)
    }

    Section(
        id: 1,
        header: Label(text: "Header 1"),
        footer: Label(text: "Footer 1"),
        cells: {
            Label(text: "Cell 5").identified(by: \.text)
            Label(text: "Cell 6").identified(by: \.text)
    })
}
