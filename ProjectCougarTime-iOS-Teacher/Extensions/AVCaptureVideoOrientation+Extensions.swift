//
//  AVCaptureVideoOrientation+Extensions.swift
//  ProjectCougarTime-iOS-Teacher
//
//  Created by Apollo Zhu on 11/24/17.
//  Copyright © 2017 Oakton High School. All rights reserved.
//

import UIKit
import AVFoundation

extension AVCaptureVideoOrientation {
    static func fromDeviceOrientation(
        _ deviceOrientation: UIDeviceOrientation
        = UIDevice.current.orientation)
    -> AVCaptureVideoOrientation? {
        switch deviceOrientation {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeLeft
        case .landscapeRight: return .landscapeRight
        default: return nil
        }
    }

    static func fromInterfaceOrientation(
        _ interfaceOrientation: UIInterfaceOrientation
        = UIApplication.shared.statusBarOrientation)
    -> AVCaptureVideoOrientation? {
        switch interfaceOrientation {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeLeft
        case .landscapeRight: return .landscapeRight
        default: return nil
        }
    }
}
