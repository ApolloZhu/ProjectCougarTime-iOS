//
//  StudentIDManualInputViewController.swift
//  ProjectCougarTime-iOS-Teacher
//
//  Created by Apollo Zhu on 11/13/17.
//  Copyright © 2017 Oakton High School. All rights reserved.
//

import UIKit

fileprivate let studentIDManualInputViewStoryboard = UIStoryboard(name: "StudentIDManualInputView", bundle: nil)

final class StudentIDManualInputViewController: UITableViewController {
    @IBOutlet private weak var inputTextField: UITextField! {
        didSet {
            oldValue?.delegate = nil
            inputTextField.delegate = self
        }
    }

    private static let newIndexPath = [IndexPath(row: 0, section: 0)]

    @IBAction private func add() {
        if inputTextField.isFirstResponder {
            if let id = newStudentID {
                students.insert(Student(id: id), at: 0)
                tableView.beginUpdates()
                tableView.insertRows(at: type(of: self).newIndexPath, with: .automatic)
                tableView.endUpdates()
            } else {
                inputTextField.resignFirstResponder()
            }
        } else {
            inputTextField.becomeFirstResponder()
        }
        inputTextField.text = ""
    }

    private var students: [Student] = []

    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        guard let parent = parent else { return }
        parent.navigationItem.rightBarButtonItem = parent.editButtonItem
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentIDManualInputTabelViewCell", for: indexPath)
        cell.textLabel?.text = "\(students[indexPath.row].id)"
        return cell
    }

    private var newStudentID: Int? {
        if let raw = inputTextField?.text?
            .trimmingCharacters(in: .whitespaces) {
            return Int(raw)
        }
        return nil
    }
}

extension StudentIDManualInputViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if isFirstResponder { add() }
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
