import XCTest
@testable import Carbon

final class UICollectionViewComponentCellTests: XCTestCase {
    func testContentProtocolEvents() {
        let cell = UICollectionViewComponentCell(frame: .zero)
        let content = MockCollectionViewCellContent()
        cell.renderedContent = content

        cell.prepareForReuse()
        cell.isHighlighted = true
        cell.isSelected = true
        cell.didRenderContent(0)
        cell.didRenderComponent(AnyComponent(A.Component()))

        XCTAssertEqual(content.cellCapturedOnPrepareForReuse, cell)
        XCTAssertEqual(content.cellCapturedOnHighlighted, cell)
        XCTAssertEqual(content.cellCapturedOnSelected, cell)
        XCTAssertEqual(content.cellCapturedOnDidRender, cell)
        XCTAssertEqual(content.cellCapturedOnDidRenderComponent, cell)
    }
}
