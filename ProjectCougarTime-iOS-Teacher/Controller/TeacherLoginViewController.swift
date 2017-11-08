//
//  TeacherLoginViewController.swift
//  ProjectCougarTime-iOS-Teacher
//
//  Created by Apollo Zhu on 11/7/17.
//  Copyright © 2017 Oakton High School. All rights reserved.
//

import UIKit

class TeacherLoginViewController: UIViewController,
UITextFieldDelegate {
    // MARK: Login

    @IBOutlet private weak var usernameTextField: UITextField! {
        didSet {
            oldValue.delegate = nil
            usernameTextField.delegate = self
        }
    }
    @IBOutlet private weak var passwordTextField: UITextField! {
        didSet {
            oldValue.delegate = nil
            passwordTextField.delegate = self
        }
    }

    @IBOutlet private weak var loginButton: UIButton!

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        loginButton.isEnabled =
            nil != usernameTextField.text
            && nil != passwordTextField.text
        return true
    }

    @IBAction private func login() {
        present(StudentIDScannerViewController(),
                animated: true, completion: nil)
    }

    // Mark: Biometric Authentication
    @IBOutlet weak var useBiometricAuthenticationStackView: UIStackView!
    @IBOutlet private weak var useBiometricAuthenticationSwitch: UISwitch!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        useBiometricAuthenticationStackView.isHidden = !BiometricAuthentication.isAvailable
    }
    @IBAction private func showInfoAboutBiometricAuthentication() {

    }
}
