import UIKit

/// 导航栏加载指示器配置
public struct LoadingIndicatorConfig {
    public let activityColor: UIColor
    public let titleFont: UIFont
    public let title: String
    public let titleColor: UIColor
    public let activitySize: CGFloat
    
    public init(
        activityColor: UIColor = .systemGray,
        titleFont: UIFont = .systemFont(ofSize: 16),
        title: String = "加载中...",
        titleColor: UIColor = .red,
        activitySize: CGFloat = 20
    ) {
        self.activityColor = activityColor
        self.titleFont = titleFont
        self.title = title
        self.titleColor = titleColor
        self.activitySize = activitySize
    }
}

/// 导航栏加载指示器
public final class NavigationBarLoadingIndicator: UIView {
    
    private let config: LoadingIndicatorConfig
    private let activityIndicator = UIActivityIndicatorView()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    
    public init(config: LoadingIndicatorConfig = LoadingIndicatorConfig()) {
        self.config = config
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 配置ActivityIndicator
        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        } else {
            activityIndicator.style = .gray
        }
        activityIndicator.color = config.activityColor
        
        // 配置标题
        titleLabel.text = config.title
        titleLabel.font = config.titleFont
        titleLabel.textColor = config.titleColor
        titleLabel.textAlignment = .center
        
        // 配置StackView
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(titleLabel)
        
        addSubview(stackView)
        
        // 设置约束
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
        
        // 设置ActivityIndicator尺寸
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.widthAnchor.constraint(equalToConstant: config.activitySize),
            activityIndicator.heightAnchor.constraint(equalToConstant: config.activitySize)
        ])
    }
    
    /// 开始加载动画
    public func startLoading() {
        activityIndicator.startAnimating()
        isHidden = false
    }
    
    /// 停止加载动画
    public func stopLoading() {
        activityIndicator.stopAnimating()
        isHidden = true
    }
}

// MARK: - UIViewController Extension for Loading
public extension UIViewController {
    
    /// 显示导航栏加载指示器
    func showNavigationBarLoading(config: LoadingIndicatorConfig = LoadingIndicatorConfig()) {
        let loadingIndicator = NavigationBarLoadingIndicator(config: config)
        navigationItem.titleView = loadingIndicator
        loadingIndicator.startLoading()
    }
    
    /// 隐藏导航栏加载指示器
    func hideNavigationBarLoading() {
        if let loadingIndicator = navigationItem.titleView as? NavigationBarLoadingIndicator {
            loadingIndicator.stopLoading()
        }
        navigationItem.titleView = nil
    }
}
