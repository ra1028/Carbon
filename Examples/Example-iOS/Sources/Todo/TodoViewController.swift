import UIKit
import Carbon
import SwipeCellKit

final class TodoViewController: UIViewController, UITextViewDelegate {
    enum ID {
        case task
        case completed
    }

    struct State {
        var todos = [Todo]()
        var completed = [Todo]()
    }

    @IBOutlet var tableView: UITableView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var inputTextView: UITextView!
    @IBOutlet var inputContainerView: UIView!
    @IBOutlet var inputViewHidden: NSLayoutConstraint!
    @IBOutlet var inputViewBottom: NSLayoutConstraint!

    var state = State() {
        didSet { render() }
    }

    private let renderer = Renderer(
        adapter: SwipeCellKitTodoAdapter(),
        updater: UITableViewUpdater()
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Todo App"
        addButton.layer.cornerRadius = addButton.bounds.height / 2
        inputTextView.textContainerInset = .zero
        inputContainerView.layer.cornerRadius = 24

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        tableView.contentInset.bottom = view.bounds.height - addButton.frame.minY
        renderer.target = tableView

        render()
    }

    func render() {
        renderer.render {
            if state.todos.isEmpty {
                Section(id: ID.task, header: TodoEmpty())
            }
            else {
                Section(
                    id: ID.task,
                    header: Header(title: "TASKS (\(state.todos.count))"),
                    cells: {
                        CellGroup(of: state.todos.enumerated()) { offset, todo in
                            TodoText(todo: todo, isCompleted: false) { [weak self] event in
                                switch event {
                                case .toggleCompleted:
                                    self?.state.todos.remove(at: offset)
                                    self?.state.completed.append(todo)

                                case .delete:
                                    self?.state.todos.remove(at: offset)
                                }
                            }
                        }
                })
            }

            if !state.completed.isEmpty {
                Section(
                    id: ID.completed,
                    header: Header(title: "COMPLETED (\(state.completed.count))"),
                    cells: {
                        CellGroup(of: state.completed.enumerated()) { offset, todo in
                            TodoText(todo: todo, isCompleted: true) { [weak self] event in
                                switch event {
                                case .toggleCompleted:
                                    self?.state.completed.remove(at: offset)
                                    self?.state.todos.append(todo)

                                case .delete:
                                    self?.state.completed.remove(at: offset)
                                }
                            }
                        }
                })
            }
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text == "\n", let inputText = textView.text, !inputText.isEmpty  else {
            return true
        }

        let id = Todo.ID()
        state.todos.append(Todo(id: id, text: inputText))
        inputTextView.resignFirstResponder()
        textView.text = nil

        return false
    }

    @IBAction func startInput() {
        inputTextView.text = nil
        inputTextView.becomeFirstResponder()
    }

    @objc func keyboardWillShow(notification: Notification) {
        KeyboardInfo(notification).animate { info in
            self.inputViewHidden.isActive = false
            self.inputViewBottom.constant = self.view.bounds.height - info.endFrame.minY
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        KeyboardInfo(notification).animate { _ in
            self.inputViewHidden.isActive = true
            self.inputViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}

extension SwipeTableViewCell: ComponentRenderable {}

final class SwipeCellKitTodoAdapter: UITableViewAdapter, SwipeTableViewCellDelegate {
    override func cellRegistration(tableView: UITableView, indexPath: IndexPath, node: CellNode) -> CellRegistration {
        return CellRegistration(class: SwipeTableViewCell.self)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.selectionStyle = .none
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

private struct KeyboardInfo {
    var userInfo: [AnyHashable: Any]
    var endFrame: CGRect
    var animationDuration: TimeInterval
    var animationOptions: UIView.AnimationOptions

    init(_ notification: Notification) {
        userInfo = notification.userInfo!
        endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        animationOptions = UIView.AnimationOptions(rawValue: userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt)
    }

    func animate(_ animations: @escaping (KeyboardInfo) -> Void) {
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: animationOptions,
            animations: { animations(self) }
        )
    }
}
