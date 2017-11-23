//
//  UIViewController+Extensions.swift
//  ProjectCougarTime-iOS-Teacher
//
//  Created by Apollo Zhu on 11/13/17.
//  Copyright © 2017 Oakton High School. All rights reserved.
//

import UIKit

extension UIViewController {
    var navigationBarColor: UIColor? {
        get {
            return navigationController?.navigationBar.barTintColor
        }
        set {
            guard let navBar = navigationController?.navigationBar,
                let color = newValue else { return }
            navBar.barTintColor = color
            let fgColor: UIColor = color.isDark ? .white: .black
            navBar.tintColor = fgColor
            navBar.titleTextAttributes = [.foregroundColor: fgColor]
            if #available(iOS 11.0, *) {
                navBar.largeTitleTextAttributes = [.foregroundColor: fgColor]
            }
        }
    }
}
