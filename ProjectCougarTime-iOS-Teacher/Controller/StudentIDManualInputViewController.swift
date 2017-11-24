//
//  StudentIDManualInputViewController.swift
//  ProjectCougarTime-iOS-Teacher
//
//  Created by Apollo Zhu on 11/13/17.
//  Copyright © 2017 Oakton High School. All rights reserved.
//

import UIKit

fileprivate let studentIDManualInputViewStoryboard = UIStoryboard(name: "StudentIDManualInputView", bundle: nil)

final class StudentIDManualInputViewController: UITableViewController, UITextFieldDelegate {
    // MARK: Input Text Field
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        return label
    }()
    
    @IBOutlet private weak var inputTextField: UITextField! {
        didSet {
            oldValue?.delegate = nil
            inputTextField.delegate = self
            
            let toolbar = UIToolbar()
            toolbar.items = [
                UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelInput)),
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(customView: statusLabel),
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add)),
            ]
            toolbar.sizeToFit()
            inputTextField.inputAccessoryView = toolbar
        }
    }
    
    private var status: String {
        get {
            return statusLabel.text ?? ""
        }
        set {
            statusLabel.text = newValue
            statusLabel.sizeToFit()
            inputTextField.inputAccessoryView?.sizeToFit()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        status = ""
    }
    
    @objc private func cancelInput() {
        status = ""
        inputTextField.text = ""
        inputTextField.resignFirstResponder()
    }
    
    private static let newIndexPath = [IndexPath(row: 0, section: 0)]
    
    @IBAction private func add() {
        if inputTextField.isFirstResponder {
            if let id = newStudentID {
                Student(id: id).checkIn(at: "Some Classroom")
                let prefix = NSLocalizedStringPrefix()
                status = String(format:
                    NSLocalizedString("\(prefix).status", value: "Added %@",
                                      comment: "Display status after added one student with id %@"), "\(id)")
                tableView.beginUpdates()
                tableView.insertRows(at: type(of: self).newIndexPath, with: .automatic)
                tableView.endUpdates()
                inputTextField.text = ""
            } else {
                cancelInput()
            }
        } else {
            status = ""
            inputTextField.becomeFirstResponder()
        }
    }

    private var originalRightBarButtonItems: [UIBarButtonItem]?
    private var originalUseSafeArea: Bool?

    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        guard let parent = parent else { return }
        parent.navigationItem.rightBarButtonItem = parent.editButtonItem
        (parent as? StudentIDInputContainerViewController)?.useSafeArea = true
    }
    
    override func willMove(toParentViewController newParent: UIViewController?) {
        if let newParent = newParent {
            originalRightBarButtonItems = newParent.navigationItem.rightBarButtonItems
            originalUseSafeArea = (newParent as? StudentIDInputContainerViewController)?.useSafeArea
        } else {
            parent?.navigationItem.rightBarButtonItems = originalRightBarButtonItems
            (parent as? StudentIDInputContainerViewController)?.useSafeArea = originalUseSafeArea ?? false
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return Student.checkedIn.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentIDManualInputTabelViewCell", for: indexPath)
        cell.textLabel?.text = "\(Student.checkedIn[indexPath.row].id)"
        return cell
    }
    
    private var newStudentID: Int? {
        if let raw = inputTextField?.text?
            .trimmingCharacters(in: .whitespaces) {
            return Int(raw)
        }
        return nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension StudentIDManualInputViewController: StudentIDInputMethod {
    static var identifier: String { return "Manual" }
    
    static var localizedName: String {
        let prefix = NSLocalizedStringPrefix()
        return NSLocalizedString(
            "\(prefix)",
            value: "Manual Input",
            comment: "Input method is by typing")
    }
    
    static var isSupported: Bool { return true }
    
    class func instantiate() -> StudentIDInputViewController {
        return studentIDManualInputViewStoryboard
            .instantiateInitialViewController()
            as! StudentIDManualInputViewController
    }
}
