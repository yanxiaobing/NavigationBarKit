# NavigationBarKit

一个现代化的 iOS 导航栏管理库，提供简洁的 API 和强大的自定义功能。

## 特性

- ✅ 简洁优雅的 API 设计
- ✅ 支持 Swift Package Manager
- ✅ 完全类型安全
- ✅ 自动返回按钮管理
- ✅ 平滑的页面过渡动画
- ✅ 丰富的样式预设
- ✅ 支持自定义按钮和事件
- ✅ 内置加载指示器
- ✅ iOS 11+ 支持

## 安装

### Swift Package Manager

#### 方式一：本地路径（推荐用于开发）

在 Xcode 中：
1. File → Add Package Dependencies
2. 输入本地路径：`/path/to/NavigationBarKit`
3. 点击 Add Package

#### 方式二：Git 仓库

在 Xcode 中：
1. File → Add Package Dependencies
2. 输入仓库 URL：`https://github.com/your-repo/NavigationBarKit`
3. 选择版本并添加到项目

或在 `Package.swift` 中添加：

```swift
dependencies: [
    .package(url: "https://github.com/your-repo/NavigationBarKit", from: "2.0.0")
]
```

## 快速开始

### 1. 初始化

在 AppDelegate 中初始化：

```swift
import NavigationBarKit

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // 使用默认配置初始化
    NavigationBarKit.initialize()
    
    // 或使用自定义配置
    NavigationBarKit.initialize(
        defaultStyle: .default,
        autoBackButton: true,
        smoothTransition: true
    )
    
    return true
}
```

### 2. 基本使用

```swift
import NavigationBarKit

class MyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航栏样式
        navigationBarStyle = .dark
        
        // 添加右侧按钮
        addRightButton(.text("保存", color: .white) {
            print("保存按钮被点击")
        })
        
        // 自定义返回按钮事件
        setBackAction {
            // 自定义返回逻辑
            self.navigationController?.popViewController(animated: true)
        }
    }
}
```

## 详细用法

### 样式配置

#### 使用预设样式

```swift
// 默认样式
navigationBarStyle = .default

// 透明样式
navigationBarStyle = .transparent

// 深色样式
navigationBarStyle = .dark
```

#### 自定义样式

```swift
navigationBarStyle = NavigationBarStyle(
    backgroundColor: .systemBlue,
    titleColor: .white,
    titleFont: .boldSystemFont(ofSize: 18),
    buttonTintColor: .white,
    statusBarStyle: .lightContent,
    shadowHidden: true
)
```

### 按钮配置

#### 添加单个按钮

```swift
// 文字按钮
addRightButton(.text("完成") {
    print("完成")
})

// 图片按钮
addLeftButton(.image(UIImage(named: "menu")!) {
    print("菜单")
})

// 系统按钮
addRightButton(.system(.add) {
    print("添加")
})
```

#### 添加多个按钮

```swift
let buttons = [
    NavigationBarButton.text("取消") { print("取消") },
    NavigationBarButton.text("保存") { print("保存") }
]

NavigationBarKit.setButtons(buttons, position: .right, for: self)
```

### 加载指示器

```swift
// 显示加载
showNavigationBarLoading()

// 自定义加载样式
showNavigationBarLoading(config: LoadingIndicatorConfig(
    title: "处理中...",
    titleColor: .systemBlue
))

// 隐藏加载
hideNavigationBarLoading()
```

### 高级配置

#### 忽略特定类的 Hook

```swift
// 某些第三方库的ViewController可能需要忽略
NavigationBarKit.addIgnoredClass(SomeThirdPartyViewController.self)
```

#### 全局默认样式

```swift
// 设置全局默认样式
NavigationBarManager.shared.defaultStyle = NavigationBarStyle(
    backgroundColor: .systemBackground,
    titleColor: .label,
    buttonTintColor: .systemBlue
)
```

## API 参考

### NavigationBarStyle

导航栏样式配置结构体：

```swift
public struct NavigationBarStyle {
    public let backgroundColor: UIColor
    public let backgroundImage: UIImage?
    public let backgroundAlpha: CGFloat
    public let titleColor: UIColor
    public let titleFont: UIFont
    public let buttonTintColor: UIColor
    public let statusBarStyle: UIStatusBarStyle
    public let shadowHidden: Bool
    public let navigationBarHidden: Bool
}
```

### NavigationBarButton

导航栏按钮配置：

```swift
public struct NavigationBarButton {
    public enum Style {
        case image(UIImage, highlightedImage: UIImage? = nil)
        case text(String, color: UIColor = .systemBlue)
        case system(UIBarButtonItem.SystemItem)
    }
}
```

### UIViewController 扩展

```swift
public extension UIViewController {
    var navigationBarStyle: NavigationBarStyle { get set }
    var leftNavigationButtons: [NavigationBarButton] { get set }
    var rightNavigationButtons: [NavigationBarButton] { get set }
    var customBackAction: (() -> Void)? { get set }
    
    func setNavigationBarStyle(_ style: NavigationBarStyle)
    func addLeftButton(_ button: NavigationBarButton)
    func addRightButton(_ button: NavigationBarButton)
    func setBackAction(_ action: @escaping () -> Void)
    func showNavigationBarLoading(config: LoadingIndicatorConfig)
    func hideNavigationBarLoading()
}
```

## 迁移指南

从旧版本 QSSwiftNavigationBar 迁移：

| 旧 API | 新 API |
|--------|--------|
| `qs_navBarBarTintColor` | `navigationBarStyle.backgroundColor` |
| `qs_navBarTitleColor` | `navigationBarStyle.titleColor` |
| `qs_navBarTintColor` | `navigationBarStyle.buttonTintColor` |
| `qs_statusBarStyle` | `navigationBarStyle.statusBarStyle` |
| `qs_navBarShadowImageHidden` | `navigationBarStyle.shadowHidden` |

## 系统要求

- iOS 11.0+
- Xcode 12.0+
- Swift 5.5+

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！
