//
//  StudentIDScannerView.swift
//  ProjectCougarTime-iOS-Teacher
//
//  Created by Apollo Zhu on 11/7/17.
//  Copyright © 2017 Oakton High School. All rights reserved.
//

import UIKit
import AVKit

class StudentIDScannerView: UIView {
    
    // MARK: Capture Preview
    
    override open class var layerClass: Swift.AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    private var previewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    private lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.previewLayer.addSublayer(layer)
        return layer
    }()
    
    var session: AVCaptureSession? {
        get { return previewLayer.session }
        set {
            previewLayer.session = newValue
            previewLayer.videoGravity = .resizeAspectFill
        }
    }
    
    @objc private func updateOrientation() {
        if let orientation = AVCaptureVideoOrientation.fromDeviceOrientation()
            ?? AVCaptureVideoOrientation.fromInterfaceOrientation(),
            true == previewLayer.connection?.isVideoOrientationSupported {
            previewLayer.connection?.videoOrientation = orientation
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrientation),
                                               name: .UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrientation),
                                               name: .UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Barcode Stroking
    
    public var barcodeBorderColor: UIColor = .tianYi {
        didSet {
            shapeLayer.strokeColor = barcodeBorderColor.cgColor
        }
    }
    
    private var path = UIBezierPath() {
        didSet {
            path.lineJoinStyle = .bevel
            path.lineWidth = 3
        }
    }
    
    public func didRecognizeMetadataObject(_ objects: [AVMetadataObject]) {
        path = objects.reduce(UIBezierPath()) {
            if let rect = previewLayer
                .transformedMetadataObject(for: $1)?.bounds {
                $0.append(UIBezierPath(rect: rect))
            }
            return $0
        }
        shapeLayer.path = path.cgPath
    }
}
