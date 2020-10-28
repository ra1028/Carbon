import XCTest
@testable import Carbon

final class UITableViewComponentCellTests: XCTestCase {
    func testContentProtocolEvents() {
        let cell = UITableViewComponentCell(style: .default, reuseIdentifier: nil)
        let content = MockTableViewCellContent()
        cell.renderedContent = content

        cell.prepareForReuse()
        cell.setHighlighted(true, animated: true)
        cell.setSelected(true, animated: true)
        cell.setEditing(true, animated: true)
        cell.didRenderContent(0)
        cell.didRenderComponent(AnyComponent(A.Component()))

        XCTAssertEqual(content.cellCapturedOnPrepareForReuse, cell)
        XCTAssertEqual(content.cellCapturedOnHighlighted, cell)
        XCTAssertEqual(content.cellCapturedOnSelected, cell)
        XCTAssertEqual(content.cellCapturedOnEditing, cell)
        XCTAssertEqual(content.cellCapturedOnDidRender, cell)
        XCTAssertEqual(content.cellCapturedOnDidRenderComponent, cell)
    }
}
