import UIKit
import Carbon

final class TodoTableViewAdapter: UITableViewAdapter {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let deletable = cellNode(at: indexPath).component(as: Deletable.self) else {
            return nil
        }

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            deletable.delete()
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
