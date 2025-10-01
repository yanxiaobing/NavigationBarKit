import UIKit

/// 导航栏管理器
public final class NavigationBarManager {
    
    /// 单例
    public static let shared = NavigationBarManager()
    
    /// 全局默认样式提供者（每次调用返回新实例）
    public var defaultStyleProvider: () -> NavigationBarStyle = { .default }
    /// 便捷访问：每次获取都会创建一个新样式，避免共享引用引发联动
    public var defaultStyle: NavigationBarStyle { defaultStyleProvider() }
    
    /// 是否启用自动返回按钮
    public var autoBackButtonEnabled: Bool = true
    
    /// 是否启用平滑过渡动画
    public var smoothTransitionEnabled: Bool = true
    
    /// 忽略Hook的类列表
    public var ignoredClasses: [AnyClass] = []
    
    private let transitionAnimator = NavigationTransitionAnimator()
    
    private init() {
        setupMethodSwizzling()
    }
    
    /// 设置导航栏样式
    public func setStyle(_ style: NavigationBarStyle, for viewController: UIViewController) {
        viewController.navigationBarStyle = style
    }
    
    /// 设置导航栏按钮
    public func setButtons(_ buttons: [NavigationBarButton], position: NavigationBarButtonPosition, for viewController: UIViewController) {
        switch position {
        case .left:
            viewController.leftNavigationButtons = buttons
        case .right:
            viewController.rightNavigationButtons = buttons
        }
    }
    
    /// 设置自定义返回按钮事件
    public func setBackAction(_ action: @escaping () -> Void, for viewController: UIViewController) {
        viewController.customBackAction = action
    }
    
    // MARK: - Private Methods
    
    private func setupMethodSwizzling() {
        NavigationBarSwizzler.swizzleViewControllerMethods()
        NavigationBarSwizzler.swizzleNavigationControllerMethods()
        NavigationBarSwizzler.swizzleNavigationBarMethods()
    }
}

// MARK: - 扩展支持
extension NavigationBarManager {
    
    /// 检查类是否需要Hook
    func shouldApplyHook(for viewController: UIViewController) -> Bool {
        let vcClass: AnyClass = type(of: viewController)
        let navClass: AnyClass? = viewController.navigationController.map { type(of: $0) }

        // 忽略精确匹配或其子类；同时也支持忽略特定的 UINavigationController 类型
        for ignored in ignoredClasses {
            // VC 命中忽略
            if vcClass == ignored { return false }
            if let vcNS = vcClass as? NSObject.Type,
               let ignoredNS = ignored as? NSObject.Type,
               vcNS.isSubclass(of: ignoredNS) {
                return false
            }

            // Nav 命中忽略
            if let navClass = navClass {
                if navClass == ignored { return false }
                if let navNS = navClass as? NSObject.Type,
                   let ignoredNS = ignored as? NSObject.Type,
                   navNS.isSubclass(of: ignoredNS) {
                    return false
                }
            }
        }
        return true
    }
    
    /// 应用导航栏样式
    func applyStyle(_ style: NavigationBarStyle, to navigationController: UINavigationController, animated: Bool = true) {
        // 主线程保证
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak navigationController] in
                if let nav = navigationController {
                    self.applyStyle(style, to: nav, animated: animated)
                }
            }
            return
        }

        let navigationBar = navigationController.navigationBar

        // 统一使用 UINavigationBarAppearance（iOS 13+ 可用；最低 iOS 14）
        let appearance = UINavigationBarAppearance()
        if let backgroundImage = style.backgroundImage {
            appearance.backgroundImage = backgroundImage
        } else {
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = style.backgroundColor
        }

        appearance.titleTextAttributes = [
            .foregroundColor: style.titleColor,
            .font: style.titleFont
        ]

        if style.shadowHidden {
            appearance.shadowImage = UIImage()
            appearance.shadowColor = nil
        }

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance

        // 仍然保留透明度与 tint 等直接属性
        navigationBar.alpha = style.backgroundAlpha
        navigationBar.tintColor = style.buttonTintColor

        // 隐藏或显示导航栏
        navigationController.setNavigationBarHidden(style.navigationBarHidden, animated: animated)
    }
}
