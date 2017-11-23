//
//  TeacherLoginViewController.swift
//  ProjectCougarTime-iOS-Teacher
//
//  Created by Apollo Zhu on 11/7/17.
//  Copyright © 2017 Oakton High School. All rights reserved.
//

import UIKit

class TeacherLoginViewController: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate {
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
    
    private func tryEnableLoginButton() {
        loginButton.isEnabled = !(true == usernameTextField.text?.isEmpty
            || true == passwordTextField.text?.isEmpty)
    }
    
    @IBAction private func login() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        performSegue(withIdentifier: "ShowCheckInVCSegue", sender: loginButton)
    }
    
    // MARK: Text Field
    private var firstResponder: UITextField?
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        firstResponder = textField
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tryEnableLoginButton()
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        tryEnableLoginButton()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tryEnableLoginButton()
        textField.resignFirstResponder()
        if loginButton.isEnabled {
            login()
        } else if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tryEnableLoginButton()
    }
    
    @objc func keyBoardWillChangeFrame(_ notification: Notification) {
        guard let info = notification.userInfo,
            let animationDuration: TimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue,
            let animationCurveRawValue = (info[UIKeyboardAnimationCurveUserInfoKey] as AnyObject).uintValue,
            // let frameBegin = (info[UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue,
            let frameEnd = (info[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            else { return }
        guard false != (info[UIKeyboardIsLocalUserInfoKey] as AnyObject).boolValue else { return }
        let firstResponderMaxY = firstResponder?.frame.maxY ?? 0
        UIView.animate(
            withDuration: animationDuration, delay: 0,
            options: UIViewAnimationOptions(rawValue: animationCurveRawValue << 16),
            animations: { [weak self] in
                if frameEnd.minY < firstResponderMaxY {
                    self?.view.frame.origin.y = frameEnd.minY - firstResponderMaxY - 8
                } else {
                    self?.view.frame.origin.y = 0
                }
            }, completion: nil)
    }
    
    // Mark: Biometric Authentication
    @IBOutlet weak var useBiometricAuthenticationStackView: UIStackView!
    @IBOutlet private weak var useBiometricAuthenticationSwitch: UISwitch!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GIDSignIn.sharedInstance().uiDelegate = self
        useBiometricAuthenticationStackView.isHidden = !BiometricAuthentication.isAvailable
        navigationBarColor = .white
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillChangeFrame(_:)),
                                               name: .UIKeyboardWillChangeFrame, object: nil)
        BiometricAuthentication.authenticate { state in
            switch state {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    self?.login()
                }
            case .failure(error: let error):
                print(error?.localizedDescription ?? "Unkown ")
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction private func showInfoAboutBiometricAuthentication() {
        
    }
}
