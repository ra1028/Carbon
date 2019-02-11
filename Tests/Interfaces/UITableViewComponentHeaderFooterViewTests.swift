import XCTest
@testable import Carbon

final class UITableViewComponentHeaderFooterViewTests: XCTestCase {
    func testContentProtocolEvents() {
        let view = UITableViewComponentHeaderFooterView(reuseIdentifier: nil)
        let content = MockTableViewHeaderFooterViewContent()
        view.renderedContent = content

        view.prepareForReuse()
        view.didRenderContent(0)
        view.didRenderComponent(AnyComponent(A.Component()))

        XCTAssertEqual(content.viewCapturedOnPrepareForReuse, view)
        XCTAssertEqual(content.viewCapturedOnDidRender, view)
        XCTAssertEqual(content.viewCapturedOnDidRenderComponent, view)
    }
}
