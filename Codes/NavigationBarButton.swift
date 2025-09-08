import UIKit

/// 导航栏按钮配置
public struct NavigationBarButton {
    public enum Style {
        case image(UIImage, highlightedImage: UIImage? = nil)
        case text(String, color: UIColor = .systemBlue)
        case system(UIBarButtonItem.SystemItem)
    }
    
    public let style: Style
    public let action: () -> Void
    
    public init(style: Style, action: @escaping () -> Void) {
        self.style = style
        self.action = action
    }
}

// MARK: - 便利构造方法
public extension NavigationBarButton {
    /// 图片按钮
    static func image(_ image: UIImage, action: @escaping () -> Void) -> NavigationBarButton {
        return NavigationBarButton(style: .image(image), action: action)
    }
    
    /// 文字按钮
    static func text(_ title: String, color: UIColor = .systemBlue, action: @escaping () -> Void) -> NavigationBarButton {
        return NavigationBarButton(style: .text(title, color: color), action: action)
    }
    
    /// 系统按钮
    static func system(_ item: UIBarButtonItem.SystemItem, action: @escaping () -> Void) -> NavigationBarButton {
        return NavigationBarButton(style: .system(item), action: action)
    }
    
    /// 默认返回按钮
    static func back(action: @escaping () -> Void) -> NavigationBarButton {
        let backImage = NavigationBarAssets.defaultBackImage
        return NavigationBarButton(style: .image(backImage), action: action)
    }
}

/// 按钮位置
public enum NavigationBarButtonPosition {
    case left
    case right
}
