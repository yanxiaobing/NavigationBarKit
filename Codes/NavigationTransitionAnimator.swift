import UIKit

/// 导航栏过渡动画器
internal final class NavigationTransitionAnimator {
    
    private let transitionDuration: TimeInterval = 0.25
    
    /// 执行平滑过渡动画
    func performTransition(
        from fromStyle: NavigationBarStyle,
        to toStyle: NavigationBarStyle,
        in navigationController: UINavigationController,
        progress: CGFloat
    ) {
        let navigationBar = navigationController.navigationBar
        
        // 背景颜色过渡
        let backgroundColor = interpolateColor(
            from: fromStyle.backgroundColor,
            to: toStyle.backgroundColor,
            progress: progress
        )
        navigationBar.barTintColor = backgroundColor
        
        // 透明度过渡
        let alpha = interpolateValue(
            from: fromStyle.backgroundAlpha,
            to: toStyle.backgroundAlpha,
            progress: progress
        )
        navigationBar.alpha = alpha
        
        // 按钮颜色过渡
        let tintColor = interpolateColor(
            from: fromStyle.buttonTintColor,
            to: toStyle.buttonTintColor,
            progress: progress
        )
        navigationBar.tintColor = tintColor
        
        // 标题颜色过渡（在完成时设置，避免中间状态的颜色混合）
        if progress >= 1.0 {
            navigationBar.titleTextAttributes = [
                .foregroundColor: toStyle.titleColor,
                .font: toStyle.titleFont
            ]
        }
    }
    
    // MARK: - 插值计算
    
    private func interpolateColor(from: UIColor, to: UIColor, progress: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0, fromGreen: CGFloat = 0, fromBlue: CGFloat = 0, fromAlpha: CGFloat = 0
        var toRed: CGFloat = 0, toGreen: CGFloat = 0, toBlue: CGFloat = 0, toAlpha: CGFloat = 0
        
        from.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        to.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let red = fromRed + (toRed - fromRed) * progress
        let green = fromGreen + (toGreen - fromGreen) * progress
        let blue = fromBlue + (toBlue - fromBlue) * progress
        let alpha = fromAlpha + (toAlpha - fromAlpha) * progress
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    private func interpolateValue(from: CGFloat, to: CGFloat, progress: CGFloat) -> CGFloat {
        return from + (to - from) * progress
    }
}
