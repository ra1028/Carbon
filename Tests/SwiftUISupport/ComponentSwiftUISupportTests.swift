#if canImport(SwiftUI) && !(os(iOS) && (arch(i386) || arch(arm)))

import XCTest
import SwiftUI
@testable import Carbon

final class ComponentSwiftUISupportTests: XCTestCase {
    func testDisplayLifecycle() {
        guard #available(iOS 13.0, *) else {
            return
        }

        struct TestComponent: Component, View {
            var willDisplay: () -> Void
            var didEndDisplay: () -> Void

            func renderContent() -> UIView {
                UIView()
            }

            func render(in content: UIView) {}

            func contentWillDisplay(_ content: UIView) {
                willDisplay()
            }

            func contentDidEndDisplay(_ content: UIView) {
                didEndDisplay()
            }
        }

        var isWillDisplayCalled = false
        var isDidEndDisplayCalled = false
        let component = TestComponent(
            willDisplay: { isWillDisplayCalled = true },
            didEndDisplay: { isDidEndDisplayCalled = true }
        )
        let hostingController = UIHostingController(rootView: AnyView(component.body))

        XCTAssertFalse(isWillDisplayCalled)
        XCTAssertFalse(isDidEndDisplayCalled)

        let window = UIWindow()
        window.rootViewController = hostingController
        window.isHidden = false
        window.setNeedsLayout()
        window.layoutIfNeeded()

        XCTAssertTrue(isWillDisplayCalled)
        XCTAssertFalse(isDidEndDisplayCalled)

        hostingController.rootView = AnyView(EmptyView())
        window.setNeedsLayout()
        window.layoutIfNeeded()

        XCTAssertTrue(isWillDisplayCalled)
        XCTAssertTrue(isDidEndDisplayCalled)
    }

    func testReferenceSize() {
        guard #available(iOS 13.0, *) else {
            return
        }

        struct TestComponent: Component, View {
            static let testSize = CGSize(width: 123, height: 456)

            func renderContent() -> UIView {
                UIView()
            }

            func render(in content: UIView) {}

            func referenceSize(in bounds: CGRect) -> CGSize? {
                Self.testSize
            }
        }

        let component = TestComponent()
        let hostingController = UIHostingController(rootView: component.body)

        XCTAssertEqual(hostingController.view.sizeThatFits(.zero), TestComponent.testSize)
    }

    func testIntrinsicContentSize() {
        guard #available(iOS 13.0, *) else {
            return
        }

        struct TestComponent: Component, View {
            static let testSize = CGSize(width: 123, height: 456)

            func renderContent() -> UIView {
                UIView()
            }

            func render(in content: UIView) {}

            func intrinsicContentSize(for content: UIView) -> CGSize {
                Self.testSize
            }
        }

        let component = TestComponent()
        let hostingController = UIHostingController(rootView: component.body)

        XCTAssertEqual(hostingController.view.sizeThatFits(.zero), TestComponent.testSize)
    }
}

#endif
