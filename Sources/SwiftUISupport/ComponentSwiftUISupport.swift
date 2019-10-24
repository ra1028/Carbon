#if canImport(SwiftUI) && canImport(Combine)

import SwiftUI

@available(iOS 13.0, *)
public extension Component where Self: View {
    /// Declares the content and behavior of this view.
    var body: some View {
        ComponentView(self)
    }
}

@available(iOS 13.0, *)
private struct ComponentView<C: Component>: View {
    var component: C
    var proxy = ComponentViewProxy()

    @State var bounds: CGRect?

    init(_ component: C) {
        self.component = component
    }

    var body: some View {
        let size: CGSize? = bounds.flatMap { bounds in
            if let referenceSize = component.referenceSize(in: bounds) {
                return referenceSize
            }

            return proxy.uiView?.systemLayoutSizeFitting(
                bounds.size,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
        }

        return ComponentRepresenting(component: component, proxy: proxy)
            .frame(height: size?.height)
            .frame(idealWidth: size?.width)
            .onAppear { self.proxy.uiView?.contentWillDisplay() }
            .onDisappear { self.proxy.uiView?.contentDidEndDisplay() }
            .background(GeometryReader { geometry in
                Color.clear.preference(key: BoundsPreferenceKey.self, value: geometry.frame(in: .local))
            })
            .onPreferenceChange(BoundsPreferenceKey.self) { self.bounds = $0 }
    }
}

private struct BoundsPreferenceKey: PreferenceKey {
    static let defaultValue: CGRect? = nil

    static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {}
}

private struct ComponentRepresenting<C: Component>: UIViewRepresentable {
    var component: C
    var proxy: ComponentViewProxy

    func makeUIView(context: Context) -> UIComponentView {
        UIComponentView()
    }

    func updateUIView(_ uiView: UIComponentView, context: Context) {
        proxy.uiView = uiView
        uiView.render(component: AnyComponent(component))
    }
}

private final class UIComponentView: UIView, ComponentRenderable {
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
    }
}

private final class ComponentViewProxy {
    var uiView: UIComponentView?
}

#endif
