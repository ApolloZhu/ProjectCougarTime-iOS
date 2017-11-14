//
//  StudentIDInputMethod.swift
//  ProjectCougarTime-iOS-Teacher
//
//  Created by Apollo Zhu on 11/8/17.
//  Copyright © 2017 Oakton High School. All rights reserved.
//

import UIKit

var StudentIDInputViewControllerTypes
    : [StudentIDInputViewController.Type] = [
    StudentIDScannerViewController.self,
    StudentIDManualInputViewController.self
]

protocol StudentIDInputMethod {
    static var identifier: String { get }
    static var localizedName: String { get }
    static var isSupported: Bool { get }
    static func instantiate() -> StudentIDInputViewController
}

typealias StudentIDInputViewController = StudentIDInputMethod & UIViewController
