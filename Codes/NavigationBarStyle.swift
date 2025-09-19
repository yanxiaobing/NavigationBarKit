import UIKit

/// 导航栏样式配置
public struct NavigationBarStyle {
    /// 背景颜色
    public var backgroundColor: UIColor
    
    /// 背景图片（优先级高于背景颜色）
    public var backgroundImage: UIImage?
    
    /// 背景透明度
    public var backgroundAlpha: CGFloat
    
    /// 标题颜色
    public var titleColor: UIColor
    
    /// 标题字体
    public var titleFont: UIFont
    
    /// 按钮tint颜色
    public var buttonTintColor: UIColor
    
    /// 状态栏样式
    public var statusBarStyle: UIStatusBarStyle
    
    /// 是否隐藏底部阴影线
    public var shadowHidden: Bool
    
    /// 是否隐藏导航栏
    public var navigationBarHidden: Bool
    
    public var gestureBackClose: Bool
    
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
    /// 默认样式
    static let `default` = NavigationBarStyle()
    
    /// 透明样式
    static let transparent = NavigationBarStyle(
        backgroundColor: .clear,
        backgroundAlpha: 0.0,
        shadowHidden: true
    )
    
    /// 深色样式
    static let dark = NavigationBarStyle(
        backgroundColor: .black,
        titleColor: .white,
        buttonTintColor: .white,
        statusBarStyle: .lightContent
    )
}
