import UIKit

/// 资源管理
internal struct NavigationBarAssets {
    /// 默认返回按钮图片
    static var defaultBackImage: UIImage {
        
        // 降级使用系统图片
        if #available(iOS 13.0, *) {
            return UIImage(systemName: "chevron.left") ?? UIImage()
        } else {
            // 创建简单的返回箭头
            return createBackArrowImage()
        }
    }
    
    /// 创建简单的返回箭头图片
    private static func createBackArrowImage() -> UIImage {
        let size = CGSize(width: 24, height: 24)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 15, y: 6))
            path.addLine(to: CGPoint(x: 9, y: 12))
            path.addLine(to: CGPoint(x: 15, y: 18))
            
            path.lineWidth = 2
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            
            UIColor.systemBlue.setStroke()
            path.stroke()
        }
    }
}
