import UIKit

internal extension UIScrollView {
    var _isContetRectContainsBounds: Bool {
        return CGRect(origin: .zero, size: contentSize)
            .inset(by: availableContentInset.inverted)
            .contains(bounds)
    }

    var _maxContentOffsetX: CGFloat {
        return contentSize.width + availableContentInset.right - bounds.width
    }

    var _maxContentOffsetY: CGFloat {
        return contentSize.height + availableContentInset.bottom - bounds.height
    }

    var _isScrolling: Bool {
        return isTracking || isDragging || isDecelerating
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
