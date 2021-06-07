//
//  extensions.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/5.
//

import Foundation
import UIKit


extension UIView {
    
    public var width: CGFloat {
        return frame.width
    }
    
    public var height: CGFloat {
        return frame.height
    }
    
    public var top: CGFloat {
        return frame.origin.y
    }
    
    public var bottom: CGFloat {
        return frame.origin.y + frame.height
    }
    
    public var left: CGFloat {
        return frame.origin.x
    }
    
    public var right: CGFloat {
        return frame.origin.x + frame.width
    }
    
    public func addSubviews(_ views: UIView...) {
        views.forEach() {addSubview($0)}
    }
}

extension UIViewController {
    
    // MARK: Get Top Bar Height
    public var topBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (navigationController?.navigationBar.height ?? 0.0)
        }
        else {
            return UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
    }
    
    // MARK: AlertViewController
    public func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach() {
            alert.addAction($0)
        }
        self.present(alert, animated: true)
    }
}

extension UserDefaults {
    enum AppConfig: String {  // UserDefault Key
        case hasBeenLaunch
    }
    
    static func isFirstLaunch() -> Bool {
        let isFirst: Bool = !(UserDefaults.bool(forKey: .hasBeenLaunch) ?? false)
        if isFirst {
            UserDefaults.set(value: true, forKey: .hasBeenLaunch)
        }
        return isFirst
    }
    
    static func set(value: Bool, forKey key: AppConfig) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    static func bool(forKey key: AppConfig) -> Bool? {
        UserDefaults.standard.bool(forKey: key.rawValue)
    }
}

extension UIButton {
    
    // MARK: Image n Label 垂直置中
    func centerVertically(padding: CGFloat = 6.0) {
        
        guard let imageViewSize = self.imageView?.frame.size,
              let titleLabelSize = self.titleLabel?.frame.size else {
            return
        }
        
        let totalHeight = imageViewSize.height + titleLabelSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - imageViewSize.height),
                                            left: 0.0,
                                            bottom: 0.0,
                                            right: -titleLabelSize.width)
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0,
                                            left: -(imageViewSize.width),
                                            bottom: -(totalHeight - titleLabelSize.height),
                                            right: 0.0)
    }
}
