//
//  NavigationController.swift
//  NavigationBarKit
//
//  Created by xbingo on 2025/9/9.
//

import UIKit

public final class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
        self.navigationBar.isTranslucent = false
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    static func setupNavigationBar() -> Void {
        
        NavigationBarKit.initialize()
    }
    
    public static func navigationVC(_ rootVc : UIViewController) -> NavigationController {
        let navVc = NavigationController.init(rootViewController: rootVc)
        return navVc
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.children.count == 1) {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

extension NavigationController : UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if ((self.topViewController?.navigationBarStyle.gestureBackClose) == true) {
            return false
        }
        return self.children.count != 1
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer.state == .began && otherGestureRecognizer.view!.isKind(of: NSClassFromString("UILayoutContainerView")!) || otherGestureRecognizer.isKind(of: NSClassFromString("UIWebTouchEventsGestureRecognizer")!)
    }
}


// MARK: UINavigationControllerDelegate
extension NavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.setNavigationBarHidden(viewController.navigationBarStyle.navigationBarHidden, animated: animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        navigationController.setNavigationBarHidden(viewController.navigationBarStyle.navigationBarHidden, animated: animated)
    }
}
