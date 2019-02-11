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

let frame = CGRect(x: 0, y: 0, width: 320, height: 480)
let tableView = UITableView(frame: frame, style: .grouped)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = tableView

// Define component

struct Label: Component, Equatable {
    var text: String

    func renderContent() -> UILabel {
        return UILabel()
    }

    func render(in content: UILabel) {
        content.text = text
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: 44)
    }
}

// Create renderer

let renderer = Renderer(
    target: tableView,
    adapter: UITableViewAdapter(),
    updater: UITableViewUpdater()
)

// Render

renderer.render(
    Section(
        id: 1,
        header: ViewNode(Label(text: "Header 1")),
        cells: [
            CellNode(id: 1, component: Label(text: "Cell 1")),
            CellNode(id: 2, component: Label(text: "Cell 2")),
            CellNode(id: 3, component: Label(text: "Cell 3")),
            CellNode(id: 4, component: Label(text: "Cell 4"))
        ],
        footer: ViewNode(Label(text: "Footer 1"))
    ),
    Section(
        id: 2,
        header: ViewNode(Label(text: "Header 2")),
        cells: [
            CellNode(id: 5, component: Label(text: "Cell 5")),
            CellNode(id: 6, component: Label(text: "Cell 6")),
            CellNode(id: 7, component: Label(text: "Cell 7"))
        ],
        footer: ViewNode(Label(text: "Footer 2"))
    )
)
