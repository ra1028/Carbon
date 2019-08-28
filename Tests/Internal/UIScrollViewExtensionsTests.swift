import XCTest
@testable import Carbon

@available(iOS 11.0, *)
final class MockScrollViewExtensionsTests: XCTestCase {
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

    func testSetAdjustedContentOffsetIfNeeded() {
        let scrollView1 = MockScrollView()
        let expectedContentOffset1 = CGPoint(x: 50, y: 50)
        scrollView1.contentInset = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        scrollView1.contentSize = CGSize(width: 100, height: 200)
        scrollView1.bounds.size = CGSize(width: 30, height: 40)
        scrollView1.contentOffset = CGPoint(x: 10, y: 20)
        scrollView1._setAdjustedContentOffsetIfNeeded(expectedContentOffset1)
        XCTAssertEqual(scrollView1.contentOffset, expectedContentOffset1)

        let scrollView2 = MockScrollView()
        scrollView2.contentInset = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        scrollView2.contentSize = CGSize(width: 100, height: 20)
        scrollView2.bounds.size = CGSize(width: 30, height: 40)
        scrollView2.contentOffset = CGPoint(x: 10, y: 20)
        scrollView2._setAdjustedContentOffsetIfNeeded(CGPoint(x: 50, y: 50))
        XCTAssertEqual(scrollView2.contentOffset, CGPoint(x: 10, y: 20))

        let scrollView3 = MockScrollView()
        scrollView3._isTracking = true
        scrollView3._setAdjustedContentOffsetIfNeeded(CGPoint(x: 50, y: 50))
        XCTAssertEqual(scrollView3.contentOffset, .zero)

        let scrollView4 = MockScrollView()
        scrollView4._isDragging = true
        scrollView4._setAdjustedContentOffsetIfNeeded(CGPoint(x: 50, y: 50))
        XCTAssertEqual(scrollView4.contentOffset, .zero)

        let scrollView5 = MockScrollView()
        scrollView5._isDecelerating = true
        scrollView5._setAdjustedContentOffsetIfNeeded(CGPoint(x: 50, y: 50))
        XCTAssertEqual(scrollView5.contentOffset, .zero)

        let scrollView6 = MockScrollView()
        scrollView6.contentInset = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        scrollView6.contentSize = CGSize(width: 200, height: 200)
        scrollView6.bounds.size = CGSize(width: 30, height: 40)
        scrollView6.contentOffset = CGPoint(x: 10, y: 20)
        scrollView6._setAdjustedContentOffsetIfNeeded(CGPoint(x: 100, y: 100))
        XCTAssertEqual(scrollView6.contentOffset, CGPoint(x: 100, y: 100))

        let scrollView7 = MockScrollView()
        scrollView7.contentInset = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        scrollView7.contentSize = CGSize(width: 100, height: 200)
        scrollView7.bounds.size = CGSize(width: 30, height: 40)
        scrollView7.contentOffset = CGPoint(x: 10, y: 20)
        scrollView7._setAdjustedContentOffsetIfNeeded(CGPoint(x: 100, y: 200))
        XCTAssertEqual(scrollView7.contentOffset, CGPoint(x: 74, y: 163))
    }
}
