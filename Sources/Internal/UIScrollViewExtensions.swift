import UIKit

internal extension UIScrollView {
    var _isScrolling: Bool {
        return isTracking || isDragging || isDecelerating
    }

    func _setAdjustedContentOffsetIfNeeded(_ contentOffset: CGPoint) {
        let maxContentOffsetX = contentSize.width + availableContentInset.right - bounds.width
        let maxContentOffsetY = contentSize.height + availableContentInset.bottom - bounds.height
        let isContentRectContainsBounds = CGRect(origin: .zero, size: contentSize)
            .inset(by: availableContentInset.inverted)
            .contains(bounds)

        if isContentRectContainsBounds && !_isScrolling {
            self.contentOffset = CGPoint(
                x: min(maxContentOffsetX, contentOffset.x),
                y: min(maxContentOffsetY, contentOffset.y)
            )
        }
    }
}

private extension UIScrollView {
    var availableContentInset: UIEdgeInsets {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return adjustedContentInset
        }
        else {
            return contentInset
        }
    }
}

private extension UIEdgeInsets {
    var inverted: UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }
}
