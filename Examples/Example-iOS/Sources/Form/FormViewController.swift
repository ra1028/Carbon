import UIKit
import Carbon

final class FormViewController: UIViewController {
    enum ID {
        case about
        case note
        case detail
        case detailsInput
        case genderPicker
        case birthdayPicker
    }

    enum Gender: String, CaseIterable {
        case male = "Male"
        case female = "Female"
        case other = "Other"
    }

    struct State {
        var name: String?
        var gender: Gender?
        var birthday: Date?
        var location: String?
        var email: String?
        var job: String?
        var note: String?
        var isOpenDetails = false
        var isOpenGenderPicker = false
        var isOpenBirthdayPicker = false
    }

    @IBOutlet var tableView: UITableView!

    var state = State() {
        didSet { render() }
    }

    private let renderer = Renderer(
        adapter: UITableViewAdapter(),
        updater: UITableViewUpdater()
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile Form"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        renderer.target = tableView
        renderer.updater.deleteRowsAnimation = .middle
        renderer.updater.insertRowsAnimation = .middle
        renderer.updater.insertSectionsAnimation = .top
        renderer.updater.deleteSectionsAnimation = .top

        render()
    }

    func render() {
        renderer.render(
            Section(
                id: ID.about,
                header: ViewNode(Header(title: "ABOUT")),
                cells: [
                    CellNode(FormTextField(title: "Name", text: state.name) { [weak self] text in
                        self?.state.name = text
                    }),
                    CellNode(FormLabel(title: "Gender", text: state.gender?.rawValue) { [weak self] in
                        self?.state.isOpenGenderPicker.toggle()
                    }),
                    !state.isOpenGenderPicker ? nil : CellNode(id: ID.genderPicker, FormTextPicker(texts: Gender.allTexts) { [weak self] text in
                        self?.state.gender = Gender(rawValue: text)
                    }),
                    CellNode(FormLabel(title: "Birthday", text: state.birthday?.longText) { [weak self] in
                        self?.state.isOpenBirthdayPicker.toggle()
                    }),
                    !state.isOpenBirthdayPicker ? nil : CellNode(id: ID.birthdayPicker, FormDatePicker(date: state.birthday ?? Date()) { [weak self] date in
                        self?.state.birthday = date
                    })
                ]
            ),
            Section(
                id: ID.note,
                header: ViewNode(Header(title: "NOTE")),
                cells: [
                    CellNode(id: ID.note, FormTextView(text: state.note) { [weak self] text in
                        self?.state.note = text

                        UIView.performWithoutAnimation {
                            self?.tableView.beginUpdates()
                            self?.tableView.endUpdates()
                        }
                    })
                ]
            ),
            Section(
                id: ID.detail,
                header: ViewNode(Header(title: "DETAILS")),
                cells: [
                    CellNode(FormSwitch(title: "Show Details", isOn: state.isOpenDetails) { [weak self] isOn in
                        self?.state.isOpenDetails = isOn
                    })
                ]
            ),
            !state.isOpenDetails ? nil : Section(
                id: ID.detailsInput,
                header: ViewNode(Spacing(height: 12)),
                cells: [
                    CellNode(FormTextField(title: "Location", text: state.location) { [weak self] text in
                        self?.state.location = text
                    }),
                    CellNode(FormTextField(title: "Email", text: state.email, keyboardType: .emailAddress) { [weak self] text in
                        self?.state.email = text
                    }),
                    CellNode(FormTextField(title: "Job", text: state.job) { [weak self] text in
                        self?.state.job = text
                    })
                ]
            )
        )
    }

    @objc func keyboardWillChangeFrame(notification: Notification) {
        let keybordFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        tableView.contentInset.bottom = view.bounds.height - keybordFrame.minY
    }
}

private extension FormViewController.Gender {
    static let allTexts = allCases.map { $0.rawValue }
}

private extension Date {
    var longText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: self)
    }
}
