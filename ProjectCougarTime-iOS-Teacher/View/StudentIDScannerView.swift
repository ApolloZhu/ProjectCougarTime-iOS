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

    var session: AVCaptureSession? {
        get { return previewLayer.session }
        set {
            previewLayer.session = newValue
            previewLayer.videoGravity = .resizeAspectFill
        }
    }
    
    @objc private func updateOrientation() {
        let statusBarOrientation = UIApplication.shared.statusBarOrientation.rawValue
        if let orientation = AVCaptureVideoOrientation(rawValue: statusBarOrientation),
            previewLayer.connection?.isVideoOrientationSupported == true {
            previewLayer.connection?.videoOrientation = orientation
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrientation),
                                               name: .UIApplicationDidChangeStatusBarOrientation, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Barcode Stroking

    public var barcodeBorderColor: UIColor = .tianYi {
        didSet {
            setNeedsDisplay()
        }
    }

    private var path = UIBezierPath() {
        didSet {
            path.lineJoinStyle = .bevel
            path.lineWidth = 3
            setNeedsDisplay()
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
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        barcodeBorderColor.setStroke()
        path.stroke()
    }
}
