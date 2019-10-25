#if canImport(SwiftUI) && canImport(Combine)

import SwiftUI

@available(iOS 13.0, *)
public extension Component where Self: View {
    /// Declares the content and behavior of this view.
    var body: some View {
        sizeFitting(.vertical)
    }

    func sizeFitting(_ axis: Axis? = nil) -> some Component & View {
        SizeFittingComponentView(self, axis: axis)
    }
}

@available(iOS 13.0, *)
private struct SizeFittingComponentView<Wrapped: Component>: View, ComponentWrapping {
    var wrapped: Wrapped
    var axis: Axis?

    private var proxy = ComponentViewProxy()
    @State private var bounds: CGRect?

    public init(_ wrapped: Wrapped, axis: Axis?) {
        self.wrapped = wrapped
        self.axis = axis
    }

    var body: some View {
        let preferredSize = self.preferredSize()
        return ComponentRepresenting(component: AnyComponent(wrapped), proxy: proxy)
            .frame(idealWidth: preferredSize.idealWidth, idealHeight: preferredSize.idealHeight)
            .frame(width: preferredSize.fixedWidth, height: preferredSize.fixedHeight)
            .clipped()
            .onAppear { self.proxy.uiView?.contentWillDisplay() }
            .onDisappear { self.proxy.uiView?.contentDidEndDisplay() }
            .background(GeometryReader { geometry in
                Color.clear.preference(key: BoundsPreferenceKey.self, value: geometry.frame(in: .local))
            })
            .onPreferenceChange(BoundsPreferenceKey.self) { self.bounds = $0 }
    }
}

@available(iOS 13.0, *)
private extension SizeFittingComponentView {
    struct Size {
        var idealWidth: CGFloat?
        var idealHeight: CGFloat?
        var fixedWidth: CGFloat?
        var fixedHeight: CGFloat?
    }

    func preferredSize() -> Size {
        guard let bounds = bounds else {
            return Size()
        }

        let referenceSize = wrapped.referenceSize(in: bounds)

        switch axis {
        case .none:
            let size = referenceSize ?? proxy.uiView?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

            return Size(
                fixedWidth: size?.width,
                fixedHeight: size?.height
            )

        case .horizontal:
            let size = referenceSize ?? proxy.uiView?.systemLayoutSizeFitting(
                CGSize(
                    width: UIView.layoutFittingCompressedSize.width,
                    height: bounds.size.height
                ),
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .required
            )

            return Size(
                idealHeight: size?.height,
                fixedWidth: size?.width
            )

        case .vertical:
            let size = referenceSize ?? proxy.uiView?.systemLayoutSizeFitting(
                CGSize(
                    width: bounds.size.width,
                    height: UIView.layoutFittingCompressedSize.height
                ),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )

            return Size(
                idealWidth: size?.width,
                fixedHeight: size?.height
            )
        }
    }
}

private struct BoundsPreferenceKey: PreferenceKey {
    static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {}
}

private struct ComponentRepresenting: UIViewRepresentable {
    var component: AnyComponent
    var proxy: ComponentViewProxy

    func makeUIView(context: Context) -> UIComponentView {
        UIComponentView()
    }

    func updateUIView(_ uiView: UIComponentView, context: Context) {
        proxy.uiView = uiView
        uiView.render(component: component)
    }
}

private final class UIComponentView: UIView, ComponentRenderable {
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class ComponentViewProxy {
    var uiView: UIComponentView?
}

#endif
