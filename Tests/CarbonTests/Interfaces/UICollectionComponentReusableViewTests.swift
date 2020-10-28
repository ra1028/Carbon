import XCTest
@testable import Carbon

final class UICollectionComponentReusableViewTests: XCTestCase {
    func testContentProtocolEvents() {
        let view = UICollectionComponentReusableView(frame: .zero)
        let content = MockCollectionReusableViewContent()
        view.renderedContent = content

        view.prepareForReuse()
        view.didRenderContent(0)
        view.didRenderComponent(AnyComponent(A.Component()))

        XCTAssertEqual(content.viewCapturedOnPrepareForReuse, view)
        XCTAssertEqual(content.viewCapturedOnDidRender, view)
        XCTAssertEqual(content.viewCapturedOnDidRenderComponent, view)
    }
}
