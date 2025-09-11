import UIKit

/// 导航栏管理器
public final class NavigationBarManager {
    
    /// 单例
    public static let shared = NavigationBarManager()
    
    /// 全局默认样式
    public var defaultStyle: NavigationBarStyle = .default
    
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
        let navigationBar = navigationController.navigationBar
        
        // 设置背景
        if let backgroundImage = style.backgroundImage {
            navigationBar.setBackgroundImage(backgroundImage, for: .default)
        } else {
            navigationBar.setBackgroundImage(nil, for: .default)
            navigationBar.barTintColor = style.backgroundColor
        }
        
        // 设置透明度
        navigationBar.alpha = style.backgroundAlpha
        
        // 设置标题样式
        navigationBar.titleTextAttributes = [
            .foregroundColor: style.titleColor,
            .font: style.titleFont
        ]
        
        // 设置按钮颜色
        navigationBar.tintColor = style.buttonTintColor
        
        // 设置阴影线
        navigationBar.shadowImage = style.shadowHidden ? UIImage() : nil
        
        // 设置导航栏隐藏状态
        navigationController.setNavigationBarHidden(style.navigationBarHidden, animated: animated)
        
        // iOS 15+ 适配
        if #available(iOS 15.0, *) {
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
        }
    }
}
