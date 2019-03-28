import XCTest
@testable import Carbon

@available(iOS 11.0, *)
final class MockScrollViewExtensionsTests: XCTestCase {
    func testIsContetRectContainsBounds() {
        let scrollView1 = MockScrollView()
        scrollView1.contentInset = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        scrollView1.contentSize = CGSize(width: 100, height: 200)
        scrollView1.bounds.size = CGSize(width: 30, height: 40)
        scrollView1.contentOffset = CGPoint(x: 10, y: 20)

        let scrollView2 = MockScrollView()
        scrollView2.contentInset = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        scrollView2.contentSize = CGSize(width: 100, height: 20)
        scrollView2.bounds.size = CGSize(width: 30, height: 40)
        scrollView2.contentOffset = CGPoint(x: 10, y: 20)

        let scrollView3 = MockScrollView()
        scrollView3.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 21, right: 11)
        scrollView3.contentSize = CGSize(width: 100, height: 200)
        scrollView3.bounds.size = CGSize(width: 100, height: 200)
        scrollView3.contentOffset = CGPoint(x: 10, y: 20)

        XCTAssertTrue(scrollView1._isContetRectContainsBounds)
        XCTAssertFalse(scrollView2._isContetRectContainsBounds)
        XCTAssertTrue(scrollView3._isContetRectContainsBounds)
    }

    func testIsScrolling() {
        let scrollView1 = MockScrollView()
        scrollView1._isTracking = true

        let scrollView2 = MockScrollView()
        scrollView2._isDragging = true

        let scrollView3 = MockScrollView()
        scrollView3._isDecelerating = true

        XCTAssertTrue(scrollView1._isScrolling)
        XCTAssertTrue(scrollView2._isScrolling)
        XCTAssertTrue(scrollView3._isScrolling)
    }

    func textMaxContentOffsetX() {
        let scrollView = MockScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        scrollView.contentSize = CGSize(width: 100, height: 200)
        scrollView.bounds.size = CGSize(width: 30, height: 40)
        scrollView.contentOffset = CGPoint(x: 10, y: 20)

        XCTAssertEqual(scrollView._maxContentOffsetX, 74)
    }

    func textMaxContentOffsetY() {
        let scrollView = MockScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        scrollView.contentSize = CGSize(width: 100, height: 200)
        scrollView.bounds.size = CGSize(width: 30, height: 40)
        scrollView.contentOffset = CGPoint(x: 10, y: 20)

        XCTAssertEqual(scrollView._maxContentOffsetY, 163)
    }
}
