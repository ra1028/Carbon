import UIKit

extension UIColor {
    static let primaryBlack = UIColor(named: "primaryBlack")!
    static let secondaryBlack = UIColor(named: "secondaryBlack")!
    static let primaryWhite = UIColor(named: "primaryWhite")!
    static let primaryGreen = UIColor(named: "primaryGreen")!

    func image(with size: CGSize = CGSize(width: 1 / UIScreen.main.scale, height: 1 / UIScreen.main.scale)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { context in
            context.cgContext.setFillColor(cgColor)
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension UITableView {
    open override func touchesShouldCancel(in view: UIView) -> Bool {
        return true
    }
}

extension UICollectionView {
    open override func touchesShouldCancel(in view: UIView) -> Bool {
        return true
    }
}

extension UINavigationController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .portrait
    }
}
