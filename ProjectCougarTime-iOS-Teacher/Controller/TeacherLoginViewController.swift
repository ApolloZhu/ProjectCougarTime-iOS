//
//  TeacherLoginViewController.swift
//  ProjectCougarTime-iOS-Teacher
//
//  Created by Apollo Zhu on 11/7/17.
//  Copyright © 2017 Oakton High School. All rights reserved.
//

import UIKit

class TeacherLoginViewController: UIViewController, UITextFieldDelegate {
    // MARK: Login
    @IBOutlet private weak var usernameTextField: UITextField! {
        didSet {
            oldValue?.delegate = nil
            usernameTextField.delegate = self
        }
    }

    @IBOutlet private weak var passwordTextField: UITextField! {
        didSet {
            oldValue?.delegate = nil
            passwordTextField.delegate = self
        }
    }

    @IBOutlet private weak var loginButton: UIButton!

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        loginButton.isEnabled = !(true == usernameTextField.text?.isEmpty
            || true == passwordTextField.text?.isEmpty)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.isFirstResponder else { return }
        textField.resignFirstResponder()
        loginButton.isEnabled = !(true == usernameTextField.text?.isEmpty
            || true == passwordTextField.text?.isEmpty)
        if (textField == usernameTextField) {
            passwordTextField.becomeFirstResponder()
        } else if loginButton.isEnabled {
            login()
        }
    }

    @IBAction private func login() {
        performSegue(withIdentifier: "ShowCheckInVCSegue", sender: loginButton)
    }

    // Mark: Biometric Authentication
    @IBOutlet weak var useBiometricAuthenticationStackView: UIStackView!
    @IBOutlet private weak var useBiometricAuthenticationSwitch: UISwitch!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        useBiometricAuthenticationStackView.isHidden = !BiometricAuthentication.isAvailable
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.barTintColor = .white
        navBar.tintColor = .black
        if #available(iOS 11.0, *) {
            navBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            navigationItem.largeTitleDisplayMode = .always
        }
    }

    @IBAction private func showInfoAboutBiometricAuthentication() {

    }
}
