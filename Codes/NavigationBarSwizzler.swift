import UIKit
import ObjectiveC

/// 方法交换管理器
internal final class NavigationBarSwizzler {
    
    private static var isSwizzled = false
    
    /// 交换UIViewController相关方法
    static func swizzleViewControllerMethods() {
        guard !isSwizzled else { return }
        
        let viewControllerClass = UIViewController.self
        
        // 交换生命周期方法
        swizzleMethod(
            class: viewControllerClass,
            originalSelector: #selector(UIViewController.viewWillAppear(_:)),
            swizzledSelector: #selector(UIViewController.nb_viewWillAppear(_:))
        )
        
        swizzleMethod(
            class: viewControllerClass,
            originalSelector: #selector(UIViewController.viewDidAppear(_:)),
            swizzledSelector: #selector(UIViewController.nb_viewDidAppear(_:))
        )
        
        swizzleMethod(
            class: viewControllerClass,
            originalSelector: #selector(UIViewController.viewWillDisappear(_:)),
            swizzledSelector: #selector(UIViewController.nb_viewWillDisappear(_:))
        )
        
        // 交换状态栏样式方法
        swizzleMethod(
            class: viewControllerClass,
            originalSelector: #selector(getter: UIViewController.preferredStatusBarStyle),
            swizzledSelector: #selector(getter: UIViewController.nb_preferredStatusBarStyle)
        )
    }
    
    /// 交换UINavigationController相关方法
    static func swizzleNavigationControllerMethods() {
        let navigationControllerClass = UINavigationController.self
        
        // 交换push方法
        swizzleMethod(
            class: navigationControllerClass,
            originalSelector: #selector(UINavigationController.pushViewController(_:animated:)),
            swizzledSelector: #selector(UINavigationController.nb_pushViewController(_:animated:))
        )
        
        // 交换pop方法
        swizzleMethod(
            class: navigationControllerClass,
            originalSelector: #selector(UINavigationController.popViewController(animated:)),
            swizzledSelector: #selector(UINavigationController.nb_popViewController(animated:))
        )
        
        swizzleMethod(
            class: navigationControllerClass,
            originalSelector: #selector(UINavigationController.popToViewController(_:animated:)),
            swizzledSelector: #selector(UINavigationController.nb_popToViewController(_:animated:))
        )
        
        swizzleMethod(
            class: navigationControllerClass,
            originalSelector: #selector(UINavigationController.popToRootViewController(animated:)),
            swizzledSelector: #selector(UINavigationController.nb_popToRootViewController(animated:))
        )
    }
    
    /// 交换UINavigationBar相关方法
    static func swizzleNavigationBarMethods() {
        // 可以在这里添加对UINavigationBar的方法交换
        isSwizzled = true
    }
    
    // MARK: - Helper Methods
    
    private static func swizzleMethod(class: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(`class`, originalSelector),
              let swizzledMethod = class_getInstanceMethod(`class`, swizzledSelector) else {
            print("NavigationBarKit: Failed to swizzle method \(originalSelector)")
            return
        }
        
        let didAddMethod = class_addMethod(
            `class`,
            originalSelector,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod)
        )
        
        if didAddMethod {
            class_replaceMethod(
                `class`,
                swizzledSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}

// MARK: - UIViewController Swizzled Methods
extension UIViewController {
    
    @objc func nb_viewWillAppear(_ animated: Bool) {
        nb_viewWillAppear(animated)
        
        guard NavigationBarManager.shared.shouldApplyHook(for: self) else { return }
        
        isTransitioning = false
        updateNavigationButtons()
        // 与系统转场同步：在转场协调器中应用样式，包含交互式返回手势
        if let nav = navigationController, let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: { [weak self] _ in
                guard let self = self else { return }
                NavigationBarManager.shared.applyStyle(self.navigationBarStyle, to: nav, animated: true)
            }, completion: nil)
        } else {
            // 无转场时立即应用
            applyNavigationBarStyleIfNeeded()
        }
    }
    
    @objc func nb_viewDidAppear(_ animated: Bool) {
        nb_viewDidAppear(animated)
        
        guard NavigationBarManager.shared.shouldApplyHook(for: self) else { return }
        
        applyNavigationBarStyleIfNeeded()
        
        // 设置状态栏样式
        setNeedsStatusBarAppearanceUpdate()
    }
    
    @objc func nb_viewWillDisappear(_ animated: Bool) {
        nb_viewWillDisappear(animated)
        
        guard NavigationBarManager.shared.shouldApplyHook(for: self) else { return }
        
        isTransitioning = true
    }
    
    @objc var nb_preferredStatusBarStyle: UIStatusBarStyle {
        // 被忽略的类返回原实现
        guard NavigationBarManager.shared.shouldApplyHook(for: self) else {
            return nb_preferredStatusBarStyle
        }
        return navigationBarStyle.statusBarStyle
    }
}

// MARK: - UINavigationController Swizzled Methods
extension UINavigationController {
    
    @objc func nb_pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 标记正在转场
        topViewController?.isTransitioning = true
        viewController.isTransitioning = true
        
        nb_pushViewController(viewController, animated: animated)
        
        // 转场完成后重置状态
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            viewController.isTransitioning = false
        }
    }
    
    @objc func nb_popViewController(animated: Bool) -> UIViewController? {
        topViewController?.isTransitioning = true
        
        let poppedVC = nb_popViewController(animated: animated)
        
        // 转场完成后重置状态
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.topViewController?.isTransitioning = false
        }
        
        return poppedVC
    }
    
    @objc func nb_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        topViewController?.isTransitioning = true
        
        let poppedVCs = nb_popToViewController(viewController, animated: animated)
        
        // 转场完成后重置状态
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            viewController.isTransitioning = false
        }
        
        return poppedVCs
    }
    
    @objc func nb_popToRootViewController(animated: Bool) -> [UIViewController]? {
        topViewController?.isTransitioning = true
        
        let poppedVCs = nb_popToRootViewController(animated: animated)
        
        // 转场完成后重置状态
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.viewControllers.first?.isTransitioning = false
        }
        
        return poppedVCs
    }
}
