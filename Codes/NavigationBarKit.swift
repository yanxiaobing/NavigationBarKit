import UIKit

/// NavigationBarKit 主入口
public final class NavigationBarKit {
    
    /// 版本号
    public static let version = "2.0.0"
    
    /// 初始化NavigationBarKit
    /// - Parameters:
    ///   - defaultStyle: 默认导航栏样式
    ///   - autoBackButton: 是否启用自动返回按钮
    ///   - smoothTransition: 是否启用平滑过渡动画
    public static func initialize(
        autoBackButton: Bool = true,
        smoothTransition: Bool = true
    ) {
        let manager = NavigationBarManager.shared
        manager.autoBackButtonEnabled = autoBackButton
        manager.smoothTransitionEnabled = smoothTransition
        
        print("NavigationBarKit v\(version) initialized")
    }
    
    /// 添加忽略Hook的类
    public static func addIgnoredClass(_ class: AnyClass) {
        NavigationBarManager.shared.ignoredClasses.append(`class`)
    }
    
    /// 移除忽略Hook的类
    public static func removeIgnoredClass(_ class: AnyClass) {
        NavigationBarManager.shared.ignoredClasses.removeAll { $0 == `class` }
    }
}

// MARK: - 便利方法
public extension NavigationBarKit {
    
    /// 为视图控制器设置导航栏样式
    static func setStyle(_ style: NavigationBarStyle, for viewController: UIViewController) {
        NavigationBarManager.shared.setStyle(style, for: viewController)
    }
    
    /// 为视图控制器设置导航按钮
    static func setButtons(_ buttons: [NavigationBarButton], position: NavigationBarButtonPosition, for viewController: UIViewController) {
        NavigationBarManager.shared.setButtons(buttons, position: position, for: viewController)
    }
    
    /// 为视图控制器设置返回按钮事件
    static func setBackAction(_ action: @escaping () -> Void, for viewController: UIViewController) {
        NavigationBarManager.shared.setBackAction(action, for: viewController)
    }
}
