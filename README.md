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
- ✅ iOS 14+ 支持

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
        
        // 方式一：使用便利方法添加按钮
        addRightButton(.text("保存", color: .white) {
            print("保存按钮被点击")
        })
        
        // 方式二：直接设置按钮数组（推荐）
        leftNavigationButtons = [.image(UIImage(named: "back_icon")!) {
            print("返回按钮被点击")
            self.navigationController?.popViewController(animated: true)
        }]
        
        // 方式三：设置多个按钮
        rightNavigationButtons = [
            .text("取消") { 
                print("取消") 
            },
            .text("保存") { 
                print("保存") 
            }
        ]
        
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

// 方法一：使用 NavigationBarKit
NavigationBarKit.setButtons(buttons, position: .right, for: self)

// 方法二：直接在 ViewController 中设置
setRightButtons(buttons)

// 方法三：直接赋值
rightNavigationButtons = buttons
```

#### 按钮管理

```swift
// 清除按钮
clearLeftButtons()
clearRightButtons()

// 添加单个按钮
addLeftButton(.text("菜单") { print("菜单") })
addRightButton(.text("更多") { print("更多") })

// 设置按钮数组
setLeftButtons([
    .text("取消") { print("取消") }
])
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
// 设置全局默认样式工厂（推荐）
NavigationBarManager.shared.defaultStyleProvider = {
    NavigationBarStyle(
        backgroundColor: .systemBackground,
        titleColor: .label,
        buttonTintColor: .systemBlue
    )
}

// 或直接设置默认样式（会创建新实例）
NavigationBarManager.shared.defaultStyle = NavigationBarStyle(
    backgroundColor: .systemBackground,
    titleColor: .label,
    buttonTintColor: .systemBlue
)
```

## 最佳实践

### 1. 批量更新样式

当需要同时修改多个样式属性时，使用 `performBatchUpdates` 避免频繁刷新：

```swift
// ✅ 推荐：批量更新，只触发一次应用
navigationBarStyle.performBatchUpdates { style in
    style.navigationBarHidden = true
    style.titleColor = .white
    style.buttonTintColor = .white
    style.shadowHidden = true
}

// ❌ 不推荐：多次单独修改，会触发多次应用
navigationBarStyle.navigationBarHidden = true
navigationBarStyle.titleColor = .white
navigationBarStyle.buttonTintColor = .white
```

### 2. 动态样式调整

利用引用语义，可以动态调整样式而无需重新创建：

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    // 初始设置
    navigationBarStyle = NavigationBarStyle(
        backgroundColor: .white,
        navigationBarHidden: false
    )
}

func hideNavigationBarWhenNeeded() {
    // ✅ 直接修改，自动应用
    navigationBarStyle.navigationBarHidden = true
}

func changeTheme() {
    // ✅ 动态切换主题
    navigationBarStyle.backgroundColor = .black
    navigationBarStyle.titleColor = .white
    navigationBarStyle.buttonTintColor = .white
}
```

### 3. 线程安全

所有样式更新都会自动在主线程执行，无需手动处理：

```swift
// ✅ 安全：后台线程调用也会自动切换到主线程
DispatchQueue.global().async {
    self.navigationBarStyle.backgroundColor = .red
}

// ✅ 推荐：直接在主线程调用
navigationBarStyle.backgroundColor = .red
```

### 4. 内存安全

在按钮回调中使用 `[weak self]` 避免循环引用：

```swift
// ✅ 推荐：使用 weak self
addRightButton(.text("保存") { [weak self] in
    self?.saveData()
})

// ❌ 避免：强引用可能导致内存泄漏
addRightButton(.text("保存") {
    self.saveData() // 可能造成循环引用
})
```

### 5. 样式继承

每个 ViewController 使用独立的样式实例：

```swift
// ✅ 推荐：每个 VC 使用独立样式
class FirstViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarStyle = NavigationBarStyle.dark
    }
}

class SecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarStyle = NavigationBarStyle.transparent
    }
}
```

### 6. 性能优化

- 使用批量更新减少刷新次数
- 避免在 `viewWillAppear` 中频繁修改样式
- 利用 16ms 合并节流机制

```swift
// ✅ 推荐：在 viewDidLoad 中设置初始样式
override func viewDidLoad() {
    super.viewDidLoad()
    navigationBarStyle = .dark
}

// ✅ 推荐：批量更新
func updateUI() {
    navigationBarStyle.performBatchUpdates { style in
        style.titleColor = .white
        style.buttonTintColor = .white
    }
}
```

## API 参考

### NavigationBarStyle

导航栏样式配置类：

```swift
public class NavigationBarStyle {
    public var backgroundColor: UIColor
    public var backgroundImage: UIImage?
    public var backgroundAlpha: CGFloat
    public var titleColor: UIColor
    public var titleFont: UIFont
    public var buttonTintColor: UIColor
    public var statusBarStyle: UIStatusBarStyle
    public var shadowHidden: Bool
    public var navigationBarHidden: Bool
    public var gestureBackClose: Bool
    
    // 批量更新方法
    public func performBatchUpdates(_ updates: (NavigationBarStyle) -> Void)
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
    // 属性
    var navigationBarStyle: NavigationBarStyle { get set }
    var leftNavigationButtons: [NavigationBarButton] { get set }
    var rightNavigationButtons: [NavigationBarButton] { get set }
    var customBackAction: (() -> Void)? { get set }
    
    // 基本方法
    func setNavigationBarStyle(_ style: NavigationBarStyle)
    func setBackAction(_ action: @escaping () -> Void)
    
    // 按钮管理方法
    func addLeftButton(_ button: NavigationBarButton)
    func addRightButton(_ button: NavigationBarButton)
    func setLeftButtons(_ buttons: [NavigationBarButton])
    func setRightButtons(_ buttons: [NavigationBarButton])
    func clearLeftButtons()
    func clearRightButtons()
    
    // 加载指示器
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

## 故障排除

### 按钮不显示的问题

如果导航栏按钮没有显示，请检查以下几点：

1. **确保在正确的时机设置按钮**
   ```swift
   override func viewDidLoad() {
       super.viewDidLoad()
       
       // ✅ 正确：在 viewDidLoad 中设置
       addRightButton(.text("保存") {
           print("保存")
       })
   }
   ```

2. **检查是否被忽略类列表包含**
   ```swift
   // 确保当前 ViewController 没有被忽略
   print("shouldApplyHook: \(NavigationBarManager.shared.shouldApplyHook(for: self))")
   ```

3. **启用调试日志**
   在 Debug 模式下，库会打印按钮设置的日志信息，帮助排查问题。

4. **手动触发更新**
   ```swift
   // 如果按钮仍然不显示，可以手动触发更新
   DispatchQueue.main.async {
       self.updateNavigationButtons()
   }
   ```

### 按钮点击事件不响应的问题

如果按钮显示了但点击没有反应，请检查：

1. **确保闭包语法正确**
   ```swift
   // ✅ 正确的写法
   leftNavigationButtons = [.image(UIImage(named: "back_icon")!) {
       print("返回按钮被点击")
       self.navigationController?.popViewController(animated: true)
   }]
   
   // ❌ 错误的写法 - 缺少闭包
   leftNavigationButtons = [.image(UIImage(named: "back_icon")!)]
   ```

2. **检查调试日志**
   在 Debug 模式下，点击按钮会打印日志：
   ```
   NavigationBarKit: 按钮被点击
   NavigationBarKit: 执行按钮回调
   ```

3. **确保图片资源存在**
   ```swift
   // 检查图片是否存在
   guard let image = UIImage(named: "back_icon") else {
       print("图片资源不存在")
       return
   }
   ```

### 样式不生效的问题

1. **确保导航栏存在**
   ```swift
   guard navigationController != nil else {
       print("NavigationController 为 nil")
       return
   }
   ```

2. **检查是否在转场过程中**
   转场过程中样式更新会被忽略，等待转场完成后再设置。

## 系统要求

- iOS 14.0+
- Xcode 12.0+
- Swift 5.5+

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！
