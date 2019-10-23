import XCTest
@testable import Carbon

final class ComponentWrappingTests: XCTestCase {
    func testForwardingActions() {
        let reuseIdentifier = "testForwardingActions"
        let referenceSize = CGSize(width: 200, height: 200)
        let intrinsicContentSize = CGSize(width: 300, height: 300)
        let shouldContentUpdate = true
        let shouldRender = true
        let content = UIView()

        let mock = MockComponent(
            reuseIdentifier: reuseIdentifier,
            referenceSize: referenceSize,
            intrinsicContentSize: intrinsicContentSize,
            shouldContentUpdate: shouldContentUpdate,
            shouldRender: shouldRender,
            content: content
        )
        let wrapper = MockComponentWrapper(wrapped: mock)
        wrapper.render(in: content)
        wrapper.layout(content: content, in: UIView())
        wrapper.contentWillDisplay(content)
        wrapper.contentDidEndDisplay(content)

        XCTAssertEqual(wrapper.reuseIdentifier, reuseIdentifier)
        XCTAssertEqual(wrapper.renderContent(), content)
        XCTAssertEqual(mock.contentCapturedOnRender, content)
        XCTAssertEqual(wrapper.referenceSize(in: .zero), referenceSize)
        XCTAssertEqual(wrapper.intrinsicContentSize(for: content), intrinsicContentSize)
        XCTAssertEqual(wrapper.shouldContentUpdate(with: wrapper), shouldContentUpdate)
        XCTAssertEqual(wrapper.shouldRender(next: wrapper, in: content), shouldRender)
        XCTAssertEqual(mock.contentCapturedOnLayout, content)
        XCTAssertEqual(mock.contentCapturedOnWillDisplay, content)
        XCTAssertEqual(mock.contentCapturedOnDidEndDisplay, content)
    }
}
