import XCTest
@testable import Carbon

final class IdentifiedComponentWrapperTests: XCTestCase {
    func testIDAndWrapped() {
        let id = 1000
        let component = A.Component()
        let wrapper = IdentifiedComponentWrapper(id: id, wrapped: component)

        XCTAssertEqual(wrapper.id, id)
        XCTAssertEqual(wrapper.wrapped, component)
    }

    func testIdentifiedOperatorWithSpecifyingID() {
        let id = 1000
        let component = A.Component()
        let wrapper = component.identified(by: id)

        XCTAssertEqual(wrapper.id, id)
        XCTAssertEqual(wrapper.wrapped, component)
    }

    func testIdentifiedOperatorWithSpecifyingKeyPath() {
        let component = A.Component()
        let wrapper = component.identified(by: \.value)

        XCTAssertEqual(wrapper.id, component.value)
        XCTAssertEqual(wrapper.wrapped, component)
    }
}
