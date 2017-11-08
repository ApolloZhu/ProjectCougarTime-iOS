//
//  NSLocalizedString+Extensions.swift
//  ProjectCougarTime-iOS-Teacher
//
//  Created by Apollo Zhu on 11/7/17.
//  Copyright © 2017 Oakton High School. All rights reserved.
//

import Foundation

func NSLocalizedStringPrefix(file: StaticString = #file,
                             function: StaticString = #function) -> String{
    return "\(file).\(function)"
}
