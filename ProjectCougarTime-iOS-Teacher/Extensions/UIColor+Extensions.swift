//
//  UIColor+Extensions.swift
//  ProjectCougarTime-iOS-Teacher
//
//  Created by Apollo Zhu on 11/13/17.
//  Copyright © 2017 Oakton High School. All rights reserved.
//

import UIKit

extension UIColor {
    static let tianYi: UIColor = #colorLiteral(red: 0.4, green: 0.8, blue: 1, alpha: 1)
    static let burgundy: UIColor = #colorLiteral(red: 0.56, green: 0.07, blue: 0.06, alpha: 1)
    static let gold: UIColor = #colorLiteral(red: 0.97, green: 0.59, blue: 0, alpha: 1)

    var isDark: Bool {
        var brightness: CGFloat = 0
        if !(getWhite(&brightness, alpha: nil)
            || getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)) {
            guard let comp = cgColor.components, comp.count > 2 else { return false }
            brightness = (comp[0] * 299 + comp[1] * 587 + comp[2] * 114) / 1000
        }
        return brightness < 0.5
    }

    var isLight: Bool {
        return !isDark
    }
}
