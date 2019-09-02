import UIKit
import Carbon

final class FormViewController: UIViewController {
    enum ID {
        case about
        case note
        case detail
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        tableView.contentInset.bottom = 150
        renderer.target = tableView
        renderer.updater.deleteRowsAnimation = .middle
        renderer.updater.insertRowsAnimation = .middle
        renderer.updater.insertSectionsAnimation = .top
        renderer.updater.deleteSectionsAnimation = .top

        render()
    }

    func render() {
        renderer.render {
            Section(id: ID.about) {
                Header(title: "ABOUT")
                    .identified(by: \.title)

                FormTextField(title: "Name", text: state.name) { [weak self] text in
                    self?.state.name = text
                }

                FormLabel(title: "Gender", text: state.gender?.rawValue) { [weak self] in
                    self?.state.isOpenGenderPicker.toggle()
                }

                if state.isOpenGenderPicker {
                    FormTextPicker(texts: Gender.allTexts) { [weak self] text in
                        self?.state.gender = Gender(rawValue: text)
                    }
                    .identified(by: ID.genderPicker)
                }

                FormLabel(title: "Birthday", text: state.birthday?.longText) { [weak self] in
                    self?.state.isOpenBirthdayPicker.toggle()
                }

                if state.isOpenBirthdayPicker {
                    FormDatePicker(date: state.birthday ?? Date()) { [weak self] date in
                        self?.state.birthday = date
                    }
                    .identified(by: ID.birthdayPicker)
                }
            }

            Section(id: ID.note) {
                Header(title: "NOTE")
                    .identified(by: \.title)

                FormTextView(text: state.note) { [weak self] text in
                    self?.state.note = text
                }
                .identified(by: ID.note)
            }

            Section(id: ID.detail) {
                Header(title: "DETAILS")
                    .identified(by: \.title)

                FormSwitch(title: "Show Details", isOn: state.isOpenDetails) { [weak self] isOn in
                    self?.state.isOpenDetails = isOn
                }

                if state.isOpenDetails {
                    Spacing(height: 12)
                        .identified(by: ID.detail)

                    FormTextField(title: "Location", text: state.location) { [weak self] text in
                        self?.state.location = text
                    }

                    FormTextField(title: "Email", text: state.email, keyboardType: .emailAddress) { [weak self] text in
                        self?.state.email = text
                    }

                    FormTextField(title: "Job", text: state.job) { [weak self] text in
                        self?.state.job = text
                    }
                }
            }
        }
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
