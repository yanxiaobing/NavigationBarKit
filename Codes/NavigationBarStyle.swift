import UIKit

/// 导航栏样式配置
public class NavigationBarStyle {
    /// 更新回调
    internal var updateHandler: (() -> Void)?
    
    /// 背景颜色
    public var backgroundColor: UIColor {
        didSet { updateHandler?() }
    }
    
    /// 背景图片（优先级高于背景颜色）
    public var backgroundImage: UIImage? {
        didSet { updateHandler?() }
    }
    
    /// 背景透明度
    public var backgroundAlpha: CGFloat {
        didSet { updateHandler?() }
    }
    
    /// 标题颜色
    public var titleColor: UIColor {
        didSet { updateHandler?() }
    }
    
    /// 标题字体
    public var titleFont: UIFont {
        didSet { updateHandler?() }
    }
    
    /// 按钮tint颜色
    public var buttonTintColor: UIColor {
        didSet { updateHandler?() }
    }
    
    /// 状态栏样式
    public var statusBarStyle: UIStatusBarStyle {
        didSet { updateHandler?() }
    }
    
    /// 是否隐藏底部阴影线
    public var shadowHidden: Bool {
        didSet { updateHandler?() }
    }
    
    /// 是否隐藏导航栏
    public var navigationBarHidden: Bool {
        didSet { updateHandler?() }
    }
    
    public var gestureBackClose: Bool {
        didSet { updateHandler?() }
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
