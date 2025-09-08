import UIKit
import ObjectiveC

// MARK: - Associated Keys
private struct AssociatedKeys {
    static var navigationBarStyle = "navigationBarStyle"
    static var leftNavigationButtons = "leftNavigationButtons"
    static var rightNavigationButtons = "rightNavigationButtons"
    static var customBackAction = "customBackAction"
    static var isTransitioning = "isTransitioning"
}

// MARK: - UIViewController Extension
public extension UIViewController {
    
    /// 导航栏样式
    var navigationBarStyle: NavigationBarStyle {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.navigationBarStyle) as? NavigationBarStyle
                ?? NavigationBarManager.shared.defaultStyle
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.navigationBarStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            applyNavigationBarStyleIfNeeded()
        }
    }
    
    /// 左侧导航按钮
    var leftNavigationButtons: [NavigationBarButton] {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.leftNavigationButtons) as? [NavigationBarButton] ?? []
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.leftNavigationButtons, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateNavigationButtons()
        }
    }
    
    /// 右侧导航按钮
    var rightNavigationButtons: [NavigationBarButton] {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.rightNavigationButtons) as? [NavigationBarButton] ?? []
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.rightNavigationButtons, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateNavigationButtons()
        }
    }
    
    /// 自定义返回按钮事件
    var customBackAction: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.customBackAction) as? () -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.customBackAction, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    /// 是否正在转场
    internal var isTransitioning: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.isTransitioning) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isTransitioning, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    // MARK: - 便利方法
    
    /// 设置导航栏样式
    func setNavigationBarStyle(_ style: NavigationBarStyle) {
        navigationBarStyle = style
    }
    
    /// 添加左侧按钮
    func addLeftButton(_ button: NavigationBarButton) {
        leftNavigationButtons.append(button)
    }
    
    /// 添加右侧按钮
    func addRightButton(_ button: NavigationBarButton) {
        rightNavigationButtons.append(button)
    }
    
    /// 设置返回按钮事件
    func setBackAction(_ action: @escaping () -> Void) {
        customBackAction = action
    }
    
    // MARK: - Internal Methods
    
    internal func applyNavigationBarStyleIfNeeded() {
        guard let navigationController = navigationController,
              !isTransitioning,
              NavigationBarManager.shared.shouldApplyHook(for: self) else {
            return
        }
        
        NavigationBarManager.shared.applyStyle(navigationBarStyle, to: navigationController)
    }
    
    internal func updateNavigationButtons() {
        // 更新左侧按钮
        if leftNavigationButtons.isEmpty {
            setupAutoBackButtonIfNeeded()
        } else {
            navigationItem.leftBarButtonItems = createBarButtonItems(from: leftNavigationButtons)
        }
        
        // 更新右侧按钮
        navigationItem.rightBarButtonItems = createBarButtonItems(from: rightNavigationButtons)
    }
    
    private func setupAutoBackButtonIfNeeded() {
        guard NavigationBarManager.shared.autoBackButtonEnabled,
              let navigationController = navigationController,
              navigationController.viewControllers.count > 1,
              navigationController.viewControllers.first != self else {
            return
        }
        
        let backButton = NavigationBarButton.back { [weak self] in
            if let customAction = self?.customBackAction {
                customAction()
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        navigationItem.leftBarButtonItem = createBarButtonItem(from: backButton)
    }
    
    private func createBarButtonItems(from buttons: [NavigationBarButton]) -> [UIBarButtonItem] {
        return buttons.map { createBarButtonItem(from: $0) }
    }
    
    private func createBarButtonItem(from button: NavigationBarButton) -> UIBarButtonItem {
        switch button.style {
        case .image(let image, let highlightedImage):
            let barButton = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
            barButton.action = #selector(handleButtonTap(_:))
            barButton.target = self
            
            // 存储action到barButton
            objc_setAssociatedObject(barButton, "action", button.action, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            
            return barButton
            
        case .text(let title, let color):
            let barButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(handleButtonTap(_:)))
            barButton.tintColor = color
            
            // 存储action到barButton
            objc_setAssociatedObject(barButton, "action", button.action, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            
            return barButton
            
        case .system(let systemItem):
            let barButton = UIBarButtonItem(barButtonSystemItem: systemItem, target: self, action: #selector(handleButtonTap(_:)))
            
            // 存储action到barButton
            objc_setAssociatedObject(barButton, "action", button.action, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            
            return barButton
        }
    }
    
    @objc private func handleButtonTap(_ sender: UIBarButtonItem) {
        if let action = objc_getAssociatedObject(sender, "action") as? () -> Void {
            action()
        }
    }
}
