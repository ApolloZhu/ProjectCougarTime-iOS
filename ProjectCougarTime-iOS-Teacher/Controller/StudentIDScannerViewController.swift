//
//  StudentIDScannerViewController.swift
//  ProjectCougarTime-iOS-Teacher
//
//  Created by Apollo Zhu on 11/7/17.
//  Copyright © 2017 Oakton High School. All rights reserved.
//

import UIKit
import AVKit

final class StudentIDScannerViewController: UIViewController {
    // MARK: Camera Setup
    private static var camera = AVCaptureDevice.default(for: .video)
    private static var input: AVCaptureDeviceInput? = {
        guard let camera = camera else { return nil }
        return try? AVCaptureDeviceInput(device: camera)
    }()
    
    private lazy var session: AVCaptureSession? = {
        let session = AVCaptureSession()
        guard let input = StudentIDScannerViewController.input else { return nil }
        session.addInput(input)
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.metadataObjectTypes = [.face, .code39]
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        session.startRunning()
        return session
    }()
    
    // MARK: Custom View Class
    override func loadView() { view = StudentIDScannerView(frame: UIScreen.main.bounds) }
    private var previewView: StudentIDScannerView { return view as! StudentIDScannerView }
    
    // MARK: View Setup
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        guard let session = session else {
            return displayDialogForUnsupportedDevice()
        }
        previewView.session = session
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    private func displayDialogForUnsupportedDevice() {
        let prefix = NSLocalizedStringPrefix()
        let alert = UIAlertController(
            title: NSLocalizedString("\(prefix).alert.title",
                value: "No Camera!",
                comment: "Title of an alert that informs user camera is not supported."),
            message: NSLocalizedString("\(prefix).alert.message",
                value: "Can not scan student IDs without a camera.",
                comment: "Message of an alert that informs user camera is not supported."),
            preferredStyle: .alert
        )
        let dismissAction = UIAlertAction(
            title: NSLocalizedString("\(prefix).dismissAction.title",
                value: "OK",
                comment: "Button of an alert that "),
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(dismissAction)
        present(alert, animated: true) { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    private var recognizedStudents: Set<Student> = [] {
        didSet {
            askCheckInStudent()
        }
    }
    
    private func askCheckInStudent() {
        for student in recognizedStudents {
            // FIXME: Actual Classroom
            student.checkIn(at: "Some Classroom")
        }
    }
}

extension StudentIDScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    // MARK: Result Handling
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        previewView.didRecognizeMetadataObject(metadataObjects)
        for metadataObject in metadataObjects {
            if let object = metadataObject as?
                AVMetadataMachineReadableCodeObject,
                let barcode = object.stringValue,
                let id = Int(barcode) {
                let student = Student(id: id)
                recognizedStudents.insert(student)
            }
        }
    }
}

extension StudentIDScannerViewController: StudentIDInputMethod {
    static var identifier: String { return "Scan" }
    
    static var localizedName: String {
        let prefix = NSLocalizedStringPrefix()
        return NSLocalizedString(
            "\(prefix)",
            value: "Scan",
            comment: "Input method is scan (barcode)")
    }
    
    static var isSupported: Bool { return nil != input }
    
    static func instantiate() -> StudentIDInputViewController {
        return StudentIDScannerViewController()
    }
}
