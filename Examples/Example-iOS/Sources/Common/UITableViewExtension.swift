import UIKit

extension UITableView {
    open override func touchesShouldCancel(in view: UIView) -> Bool {
        return true
    }
}
