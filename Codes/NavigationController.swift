import UIKit

/// 可选的内置导航控制器，提供少量常用可配置项
public final class NavigationController: UINavigationController {
    
    // MARK: - Configuration
    public struct Configuration {
        /// 当 push 到第二层页面时是否自动隐藏 TabBar（默认：true）
        public var autoHideBottomBarOnSecondPush: Bool
        /// 手势并发策略（返回 true 允许与 otherGesture 同时识别）
        public var simultaneousGestureDecider: ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)?
        
        public init(
            autoHideBottomBarOnSecondPush: Bool = true,
            simultaneousGestureDecider: ((UIGestureRecognizer, UIGestureRecognizer) -> Bool)? = nil
        ) {
            self.autoHideBottomBarOnSecondPush = autoHideBottomBarOnSecondPush
            self.simultaneousGestureDecider = simultaneousGestureDecider
        }
    }
    
    public var configuration: Configuration
    
    // MARK: - Init
    public init(rootViewController: UIViewController, configuration: Configuration = .init()) {
        self.configuration = configuration
        super.init(rootViewController: rootViewController)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.configuration = .init()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.configuration = .init()
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        navigationBar.isTranslucent = false
    }
    
    // 将状态栏样式交给顶部 VC（与 SDK 的样式 Hook 一致）
    public override var childForStatusBarStyle: UIViewController? { topViewController }
    
    // MARK: - Push Behavior
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if configuration.autoHideBottomBarOnSecondPush, viewControllers.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension NavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 根控制器禁止返回手势；当顶部 VC 指定关闭返回手势时禁止
        let isRoot = viewControllers.count <= 1
        if let top = topViewController, top.navigationBarStyle.gestureBackClose { return false }
        return !isRoot
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let decide = configuration.simultaneousGestureDecider {
            return decide(gestureRecognizer, otherGestureRecognizer)
        }
        return false
    }
}


