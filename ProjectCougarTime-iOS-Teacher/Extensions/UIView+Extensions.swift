//
//  UIView+Extensions.swift
//  ProjectCougarTime-iOS-Teacher
//
//  Created by Apollo Zhu on 2017/11/22.
//  Copyright © 2017年 Oakton High School. All rights reserved.
//

import UIKit

extension UIView {
    func constraintToSuperview() {
        guard let superview = superview else { return }
        centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        widthAnchor.constraint(equalTo: superview.widthAnchor)
        heightAnchor.constraint(equalTo: superview.heightAnchor)
    }
}
