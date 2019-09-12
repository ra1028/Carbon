import UIKit

extension UITableView {
    open override func touchesShouldCancel(in view: UIView) -> Bool {
        true
    }
}

extension UICollectionView {
    open override func touchesShouldCancel(in view: UIView) -> Bool {
        true
    }
}

extension UINavigationController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        topViewController?.supportedInterfaceOrientations ?? .portrait
    }
}
