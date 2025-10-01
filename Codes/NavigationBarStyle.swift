import UIKit

/// 导航栏样式配置
public class NavigationBarStyle {
    /// 更新回调（会被合并触发）
    internal var updateHandler: (() -> Void)?
    private var pendingUpdateWorkItem: DispatchWorkItem?
    
    /// 背景颜色
    public var backgroundColor: UIColor { didSet { scheduleUpdate() } }
    
    /// 背景图片（优先级高于背景颜色）
    public var backgroundImage: UIImage? { didSet { scheduleUpdate() } }
    
    /// 背景透明度
    public var backgroundAlpha: CGFloat { didSet { scheduleUpdate() } }
    
    /// 标题颜色
    public var titleColor: UIColor { didSet { scheduleUpdate() } }
    
    /// 标题字体
    public var titleFont: UIFont { didSet { scheduleUpdate() } }
    
    /// 按钮tint颜色
    public var buttonTintColor: UIColor { didSet { scheduleUpdate() } }
    
    /// 状态栏样式
    public var statusBarStyle: UIStatusBarStyle { didSet { scheduleUpdate() } }
    
    /// 是否隐藏底部阴影线
    public var shadowHidden: Bool { didSet { scheduleUpdate() } }
    
    /// 是否隐藏导航栏
    public var navigationBarHidden: Bool { didSet { scheduleUpdate() } }
    
    public var gestureBackClose: Bool { didSet { scheduleUpdate() } }

    /// 提供一次性的批量更新能力
    public func performBatchUpdates(_ updates: (NavigationBarStyle) -> Void) {
        let previousWorkItem = pendingUpdateWorkItem
        pendingUpdateWorkItem = nil
        updates(self)
        scheduleUpdate()
        // 恢复为普通节流（无需恢复 previousWorkItem）
    }

    private func scheduleUpdate() {
        // 合并 16ms 内的多次改动，避免频繁刷新
        pendingUpdateWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in self?.updateHandler?() }
        pendingUpdateWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.016, execute: workItem)
    }
    
    public init(
        backgroundColor: UIColor = .white,
        backgroundImage: UIImage? = nil,
        backgroundAlpha: CGFloat = 1.0,
        titleColor: UIColor = .black,
        titleFont: UIFont = .systemFont(ofSize: 17, weight: .semibold),
        buttonTintColor: UIColor = .systemBlue,
        statusBarStyle: UIStatusBarStyle = .default,
        shadowHidden: Bool = false,
        navigationBarHidden: Bool = false,
        gestureBackClose: Bool = false
    ) {
        self.backgroundColor = backgroundColor
        self.backgroundImage = backgroundImage
        self.backgroundAlpha = backgroundAlpha
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.buttonTintColor = buttonTintColor
        self.statusBarStyle = statusBarStyle
        self.shadowHidden = shadowHidden
        self.navigationBarHidden = navigationBarHidden
        self.gestureBackClose = gestureBackClose
    }
}

// MARK: - 预设样式
public extension NavigationBarStyle {
    /// 默认样式（每次调用返回新实例）
    static var `default`: NavigationBarStyle {
        return NavigationBarStyle()
    }
    
    /// 透明样式（每次调用返回新实例）
    static var transparent: NavigationBarStyle {
        return NavigationBarStyle(
            backgroundColor: .clear,
            backgroundAlpha: 0.0,
            shadowHidden: true
        )
    }
    
    /// 深色样式（每次调用返回新实例）
    static var dark: NavigationBarStyle {
        return NavigationBarStyle(
            backgroundColor: .black,
            titleColor: .white,
            buttonTintColor: .white,
            statusBarStyle: .lightContent
        )
    }
}
