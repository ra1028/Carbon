import UIKit
import Carbon
import SwipeCellKit

extension SwipeTableViewCell: ComponentRenderable {}

final class TodoSwipeCellKitAdapter: UITableViewAdapter, SwipeTableViewCellDelegate {
    override func cellRegistration(tableView: UITableView, indexPath: IndexPath, node: CellNode) -> CellRegistration {
        CellRegistration(class: SwipeTableViewCell.self)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard let deletable = cellNode(at: indexPath).component(as: Deletable.self), orientation == .right else {
            return nil
        }

        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, _ in
            deletable.delete()
            action.fulfill(with: .delete)
        }

        deleteAction.image = #imageLiteral(resourceName: "Trash")
        return [deleteAction]
    }
}
