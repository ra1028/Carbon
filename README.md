<H1 align="center">
Carbon
</H1>
<H4 align="center">
A declarative library for building component-based user interfaces</br>
in UITableView and UICollectionView.</br>
</H4>

<p align="center">
<a href="https://developer.apple.com/swift"><img alt="Swift5" src="https://img.shields.io/badge/language-Swift5-orange.svg"/></a>
<a href="https://github.com/ra1028/Carbon/releases/latest"><img alt="Release" src="https://img.shields.io/github/release/ra1028/Carbon.svg"/></a>
<a href="https://cocoapods.org/pods/Carbon"><img alt="CocoaPods" src="https://img.shields.io/cocoapods/v/Carbon.svg"/></a>
<a href="https://github.com/Carthage/Carthage"><img alt="Carthage" src="https://img.shields.io/badge/carthage-compatible-yellow.svg"/></a>
</br>
<a href="https://dev.azure.com/ra1028/GitHub/_build/latest?definitionId=2&branchName=master"><img alt="Build Status" src="https://dev.azure.com/ra1028/GitHub/_apis/build/status/ra1028.Carbon?branchName=master"/></a>
<a href="https://developer.apple.com/"><img alt="Platform" src="https://img.shields.io/badge/platform-iOS-green.svg"/></a>
<a href="https://github.com/ra1028/Carbon/blob/master/LICENSE"><img alt="Lincense" src="https://img.shields.io/badge/License-Apache%202.0-black.svg"/></a>
</p>

<p align="center">
Made with ❤️ by <a href="https://github.com/ra1028">Ryo Aoyama</a>
</p>

|Declarative|Component-Based|Non-Destructive|
|:----------|:--------------|:--------------|
|Provides a declarative design with power of diffing algorithm for building list UIs.|Declare component once, it can be reused regardless kind of the list element.|Solves the various problems by architecture and algorithm without destructing UIKit.|

---

## Introduction

Carbon is a library for building component-based user interfaces in UITableView and UICollectionView inspired by [React](https://reactjs.org).  
This make it painless to build and maintain the complex UIs.  

Uses [DifferenceKit](https://github.com/ra1028/DifferenceKit) which is highly optimized based on Paul Heckel's paper for diffing.  
Declarative design and diffing algorithm make your code more predictable, debugging easier and providing beautiful animations to users.  

Our goal is similar to [Instagram/IGListKit](https://github.com/Instagram/IGListKit) and [airbnb/Epoxy](https://github.com/airbnb/epoxy), we respect those library as pioneers.  

---

## Examples

<img src="https://raw.githubusercontent.com/ra1028/Carbon/master/assets/hello.png" height=260 align=right>

```swift
renderer.render(
    Section(
        id: ID.greet,
        header: ViewNode(Header(title: "GREET")),
        cells: [
            CellNode(HelloMessage(name: "Vincent")),
            CellNode(HelloMessage(name: "Jules")),
            CellNode(HelloMessage(name: "Butch"))
        ],
        footer: ViewNode(Footer(text: "💡 Tap anywhere"))
    )
)
```

---

|![Pangram](https://raw.githubusercontent.com/ra1028/Carbon/master/assets/pangram.gif)|![Kyoto](https://raw.githubusercontent.com/ra1028/Carbon/master/assets/kyoto.gif)|![Emoji](https://raw.githubusercontent.com/ra1028/Carbon/master/assets/emoji.gif)|![Todo](https://raw.githubusercontent.com/ra1028/Carbon/master/assets/todo.gif)|![Form](https://raw.githubusercontent.com/ra1028/Carbon/master/assets/form.gif)|
|:----------------------------:|:------------------------:|:------------------------:|:----------------------:|:----------------------:|

---

## Getting Started

- [API Documentation](https://ra1028.github.io/Carbon)
- [Example Apps](https://github.com/ra1028/Carbon/tree/master/Examples)
- [Playground](https://github.com/ra1028/Carbon/blob/master/Carbon.playground/Contents.swift)

#### Build for Development

```sh
$ git clone https://github.com/ra1028/Carbon.git
$ cd Carbon/
$ make setup
$ open Carbon.xcworkspace
```

---

## Basic Usage

Described here are the fundamentals for building list UIs with Carbon.  
[The API document](https://ra1028.github.io/Carbon) will help you understand the details of each type.  
For more advanced usage, see the [Advanced Guide](https://github.com/ra1028/Carbon#advanced-guide).  
And the more practical examples are [here](https://github.com/ra1028/Carbon/tree/master/Examples).  

#### Component

`Component` is the base unit of the UI in Carbon.  
All elements are made up of components, and it can be animated by diffing update.  
`UIView`, `UIViewController`, and its subclasses are laid out with edge constraints by default. Other classes can also be rendered as `Content` by implementing `layout` function to component.

You can declare fixed size component by implementing `referenceSize(in bounds: CGRect) -> CGSize?`.  
Returned `CGSize` value is used to the size of component on the list UI. Note that UITableView ignores width.  
If returning `nil`, it falls back to default value such as `UITableView.rowHeight` or `UICollectionViewFlowLayout.itemSize` defined in `Adapter`.  
Returns `nil` by default, it works as automatic sizing.  

Definition below is the simplest implementation.  

```swift
struct HelloMessage: Component {
    var name: String

    func renderContent() -> UILabel {
        return UILabel()
    }

    func render(in content: UILabel) {
        content.text = "Hello \(name)"
    }
}
```

#### ViewNode

This is a node representing header or footer.  
The node is wrap an instance of type conforming to `Component` protocol and works as an intermediary with `DifferenceKit` for diffing.  

```swift
ViewNode(HelloMessage(name: "Vincent"))
```

#### CellNode

`CellNode` is a node representing cell.  
Unlike in the ViewNode, this needs an `id` which `Hashable` type to identify from among a lot of cells.  
The `id` is used to find the same component in the list data before and after changed, then calculate the all kind of diff.  

- deletes
- inserts
- moves
- updates

```swift
CellNode(id: 0, HelloMessage(name: "Jules"))
```

The `id` can be predefined if conforming to [`IdentifiableComponent`](https://github.com/ra1028/Carbon#identifiablecomponent).  

```swift
CellNode(HelloMessage(name: "Jules"))
```

#### Section

`Section` has a header, a footer and a collection of cells.  
A group of cells can be contains nil, then skipped rendering of it cell.  
This also needs to specify `id` for identify from among multiple sections, then can be calculate the all kind of diff.  

- section deletes
- section inserts
- section moves
- section updates

```swift
let emptySection = Section(id: 0)
```

```swift
let showsHelloMia: Bool = ...

let section = Section(
    id: "hello",
    header: ViewNode(HelloMessage(name: "Vincent")),
    cells: [
        CellNode(HelloMessage(name: "Jules")),
        CellNode(HelloMessage(name: "Butch")),
        !showsHelloMia
            ? nil
            : CellNode(HelloMessage(name: "Mia"))
    ],
    footer: ViewNode(HelloMessage(name: "Marsellus"))
)
```

#### Renderer

The components are displayed on top of list UI by `render` via `Renderer`.  
Boilerplates such as registering element types to a table view are no longer needed in Carbon.  

The adapter acts as delegate and dataSource, the updater handles updates.  
You can also change the behaviors by inheriting the class and customizing it.  
There are also `UITableViewReloadDataUpdater` and `UICollectionViewReloadDataUpdater` which update by `reloadData` without diffing updates.  
Note that it doesn't retain `target` inside `Renderer` because it avoids circular references.  

When `render` called again, the updater calculates the diff from currently rendering components and update them with system animation.  
Since there are several style syntaxes for passing group of sections, please check the [API docs](https://ra1028.github.io/Carbon/Classes/Renderer.html).  

```swift
@IBOutlet var tableView: UITableView!

let renderer = Renderer(
    adapter: UITableViewAdapter(),
    updater: UITableViewUpdater()
)

override func viewDidLoad() {
    super.viewDidLoad()

    renderer.target = tableView
}
```

```swift
@IBOutlet var collectionView: UICollectionView!

let renderer = Renderer(
    adapter: UICollectionViewFlowLayoutAdapter(),
    updater: UICollectionViewUpdater()
)

override func viewDidLoad() {
    super.viewDidLoad()

    renderer.target = collectionView
}
```

```swift
let showsBottomSection: Bool = ...

renderer.render(
    Section(
        id: "top section",
        cells: [
            CellNode(HelloMessage(name: "Vincent")),
            CellNode(HelloMessage(name: "Jules")),
            CellNode(HelloMessage(name: "Butch"))
        ]
    ),
    !showsBottomSection
        ? nil
        : Section(
            id: "bottom section",
            header: ViewNode(HelloMessage(name: "Pumpkin")),
            cells: [
                CellNode(HelloMessage(name: "Marsellus")),
                CellNode(HelloMessage(name: "Mia"))
            ],
            footer: ViewNode(HelloMessage(name: "Honey Bunny"))
        )
)
```

<H3 align="center">
<a href="https://ra1028.github.io/Carbon">[See More Usage]</a>
</H3>

---

## Advanced Guide

#### Custom Content

Of course, the content of component can use custom class. You can also instantiate it from Xib.  
It can be inherited whichever class, but the common means is inherit `UIView` or `UIViewController`.  

<img src="https://raw.githubusercontent.com/ra1028/Carbon/master/assets/content-xib.png" height=90 align=right>

```swift
class HelloMessageContent: UIView {
    @IBOutlet var label: UILabel!
}
```

``` swift
struct HelloMessage: Component {
    var name: String

    func renderContent() -> HelloMessageContent {
        return HelloMessageContent.loadFromNib()  // Extension for instantiate from Xib. Not in Carbon.
    }

    func render(in content: HelloMessageContent) {
        content.label.text = "Hello \(name)"
    }
```

#### IdentifiableComponent

`IdentifiableComponent` is a component that simply can predefine an identifier.  
It can be omitted the definition of `id` if the component conforms to `Hashable`.  

```swift
struct HelloMessage: IdentifiableComponent {
    var name: String

    var id: String {
        return name
    }

    ...
```

#### Selection

Cell selection can be handled by setting `didSelect` to the instance of `UITableViewAdapter` or `UICollectionViewAdapter`.  

```swift
adapter.didSelect { context in
    print(context.tableView)
    print(context.node)
    print(context.indexPath)
}
```

However, we recommend to make the `Content` of the component to the class inherited from `UIControl`.  
It's more maintainable and extensible.  

```swift
class MenuItemContent: UIControl {
    @IBOutlet var label: UILabel!

    var onSelect: (() -> Void)?

    @objc func handleSelect() {
        onSelect?()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        addTarget(self, action: #selector(handleSelect), for: .touchUpInside)
    }
}
```

```swift
struct MenuItem: Component {
    var text: String
    var onSelect: () -> Void

    func renderContent() -> MenuItemContent {
        return MenuItemContent.loadFromNib()
    }

    func render(in content: MenuItemContent) {
        content.label.text = text
        content.onSelect = onSelect
    }
}
```

In this way, in order to cancel the selection by scrolling, you need to implement the following extension.  

```swift
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
```

#### Component in-Depth

Components can define more detailed behaviors.  
Following are part of it.  

- **shouldContentUpdate(with next: Self) -> Bool**  
If the result is `true`, the component displayed as a cell is reloaded individually, header or footer is reloaded with entire section.  
By default it returns `false`, but the updater will always re-render visible components changed.  

- **referenceSize(in bounds: CGRect) -> CGSize?**  
Defining the size of component on the list UI.  
You can use default value such as `UITableView.rowHeight` or `UICollectionViewLayout.itemSize` by returning `nil`.  
Returns `nil` by default.  

- **shouldRender(next: Self, in content: Content) -> Bool**  
By returning `false`, you can skip component re-rendering when reloading or dequeuing element.  
Instead of re-rendering, detects component changes by comparing with next value.  
This is recommended to use only for performance tuning.  

- **contentWillDisplay(_ content: Content)**  
Invoked every time of before a component got into visible area.  

- **contentDidEndDisplay(_ content: Content)**  
Invoked every time of after a component went out from visible area.  

[See more](https://ra1028.github.io/Carbon/Protocols/Component.html)

#### Adapter Customization

You can add methods of `delegate`, `dataSource` by subclassing each adapter.  

```swift
class CustomTableViewdapter: UITableViewAdapter {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Header title for section\(section)"
    }
}

let renderer = Renderer(
    adapter: CustomTableViewAdapter(),
    updater: UITableViewUpdater()
)
```

Furthermore, it can be customized the class of the elements(cell/header/footer) which becomes the container of components by overriding some methods in adapter as following.  
You can also use `xib` by giving nib as parameter of init of the return value Registration.  

```swift
class CustomTableViewAdapter: UITableViewAdapter {
    // Use custom cell.
    override func cellRegistration(tableView: UITableView, indexPath: IndexPath, node: CellNode) -> CellRegistration {
        return CellRegistration(class: CustomTableViewCell.self)
    }

    // Use custom header view.
    override func headerViewRegistration(tableView: UITableView, section: Int, node: ViewNode) -> ViewRegistration {
        return ViewRegistration(class: CustomTableViewHeaderFooterView.self)
    }

    // Use custom footer view.
    override func footerViewRegistration(tableView: UITableView, section: Int, node: ViewNode) -> ViewRegistration {
        return ViewRegistration(class: CustomTableViewHeaderFooterView.self)
    }
}
```

In UICollectionViewAdapter, you can select the node corresponding to a certain kind.  

```swift
class CustomCollectionViewAdapter: UICollectionViewAdapter {
    override func supplementaryViewNode(forElementKind kind: String, collectionView: UICollectionView, at indexPath: IndexPath) -> ViewNode? {
        switch kind {
        case "CustomSupplementaryViewKindSectionHeader":
            return headerNode(in: indexPath.section)

        default:
            return super.supplementaryViewNode(forElementKind: kind, collectionView: collectionView, at: indexPath)
        }
    }
}
```

[See more](https://ra1028.github.io/Carbon/Adapters.html)

#### Updater Customization

It can be modify the updating behavior of the list UI by inheriting `Updater`.  
This is important thing to make Carbon well adapted to your project.  
Below are some of the default provided settings of `updater`.  

- **isAnimationEnabled**  
Indicating whether enables animation for diffing updates, setting `false` will perform it using `UIView.performWithoutAnimation`.  
Default is `true`.  

- **isAnimationEnabledWhileScrolling**  
Indicating whether enables animation for diffing updates while target is scrolling, setting `false` will perform it  using `UIView.performWithoutAnimation`.  
Default is `false`.  

- **animatableChangeCount**  
The max number of changes to perform diffing updates. It falls back to `reloadData` if it exceeded.  
Default is `300`.  

- **keepsContentOffset**  
Indicating whether that to reset content offset after updated.  
The content offset become unintended position after diffing updates in some case.
 If set `true`, revert content offset after updates.  
Default is `true`.  

[See more](https://ra1028.github.io/Carbon/Updaters.html)

---

## Requirements

- Swift 5.0+
- iOS 10.2+

---

## Installation

### [CocoaPods](https://cocoapods.org)
Add the following to your `Podfile`:
```ruby
pod 'Carbon'
```

### [Carthage](https://github.com/Carthage/Carthage)
Add the following to your `Cartfile`:
```
github "ra1028/Carbon"
```

---

## Contributing

Pull requests, bug reports and feature requests are welcome 🚀  
Please see the [CONTRIBUTING](https://github.com/ra1028/Carbon/blob/master/CONTRIBUTING.md) file for learn how to contribute to Carbon.  

---

## Respect

Libraries for list UIs using diffing algorithm that I have sincerely ❤️ and respected.  

- [React](https://github.com/facebook/react/) (by [Facebook](https://github.com/facebook))  
  I have very inspired about paradigm and API design.  
- [IGListKit](https://github.com/Instagram/IGListKit) (by [Instagram](https://github.com/Instagram))  
  The most popular library among list UI libraries using diffing algorithm in iOS.  
- [Epoxy](https://github.com/airbnb/epoxy) (by [Airbnb](https://github.com/airbnb))  
  The most popular library among list UI libraries using diffing algorithm in Android.  
- [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources) (by [@kzaher](https://github.com/kzaher), [RxSwift Community](https://github.com/RxSwiftCommunity))  
  A great library that can complex diffing update by very fast algorithms.  
- [Texture](https://github.com/TextureGroup/Texture) (by [TextureGroup](https://github.com/TextureGroup), [Facebook](https://github.com/facebook), [Pinterest](https://github.com/pinterest))  
  The one and only library for creating list UIs that pursues rendering performance.  
- [Bento](https://github.com/Babylonpartners/Bento) (by [Babylon Health](https://github.com/Babylonpartners))  
  Bento is an awesome declarative library that has an API design which follows React.  
- [ReactiveLists](https://github.com/plangrid/ReactiveLists) (by [PlanGrid](https://github.com/plangrid))  
  Uses DifferenceKit as well as Carbon for the diffing algorithm.  

---

## License

Carbon is released under the [Apache 2.0 License](https://github.com/ra1028/Carbon/blob/master/LICENSE).  
