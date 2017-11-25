//
//  TeacherLoginViewController.swift
//  ProjectCougarTime-iOS-Teacher
//
//  Created by Apollo Zhu on 11/7/17.
//  Copyright © 2017 Oakton High School. All rights reserved.
//

import UIKit
import GoogleSignIn

class TeacherLoginViewController: UIViewController, UITextFieldDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
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

    private var isTextFieldsFilled: Bool {
        return !(true == usernameTextField.text?.isEmpty
            || true == passwordTextField.text?.isEmpty)
    }
    
    @IBOutlet private weak var loginButton: UIButton!
    
    private func tryEnableLoginButton() {
        loginButton.isEnabled = BiometricAuthentication.isAvailable
            || isTextFieldsFilled
    }
    
    @IBAction private func login() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        guard !isTextFieldsFilled else { return loginAfterAuthed() }
        useBiometricAuthentication()
    }

    private func loginAfterAuthed() {
        GIDSignIn.sharedInstance().signOut()
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
        } else if textField == passwordTextField {
            usernameTextField.becomeFirstResponder()
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
        guard let firstResponderMaxY = firstResponder?.frame.maxY else { return }
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

    // MARK: Google Sign In
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        let prefix = NSLocalizedStringPrefix()
        guard let email = user?.profile?.email else {
            return showInfo(
                title:
                NSLocalizedString("\(prefix).noEmail.title",
                    value: "Google Sign In Failed",
                    comment: "Title of an alert."),
                message: error?.localizedDescription ??
                    NSLocalizedString("\(prefix).noEmail.message",
                        value: "Something went wrong during the process.",
                        comment: "Message saying something went wrong with google sign in.")
            )
        }
        guard email.hasSuffix("@fcps.edu") || email.hasSuffix("@fcpsschools.net") else {
            GIDSignIn.sharedInstance().signOut()
            return showInfo(
                title:
                NSLocalizedString("\(prefix).wrongSuffix.title",
                    value: "Wrong Account",
                    comment: "Title of an alert when having wrong email suffix."),
                message:
                NSLocalizedString("\(prefix).wrongSuffix.message",
                    value: "Your google account email address doesn't end in fcps.edu or fcpsschools.net!",
                    comment: "Message saying user google account suffix don't qualify.")
            )
        }
        loginAfterAuthed()
    }
    
    // MARK: Biometric Authentication
    @IBOutlet weak var useBiometricAuthenticationStackView: UIStackView!
    @IBOutlet private weak var useBiometricAuthenticationSwitch: UISwitch!
    private func useBiometricAuthentication() {
        BiometricAuthentication.authenticate { state in
            switch state {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    self?.loginAfterAuthed()
                }
            case .failure(error: let error):
                debugPrint(error?.localizedDescription ?? "Unkown ")
            }
        }
    }
    
    @IBAction private func showInfoAboutBiometricAuthentication() {
        let prefix = NSLocalizedStringPrefix()
        showInfo(
            title:
            NSLocalizedString("\(prefix).title",
                value: "What's Biometric Authentication?",
                comment: "Title of an alert explaining what's bio auth"),
            message:
            NSLocalizedString("\(prefix).message",
                value: "You can use your FaceID/TouchID to login.",
                comment: "Explaination of biometric authentication.")
        )
    }

    // MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard nil == GIDSignIn.sharedInstance().currentUser
            else { return login() }
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        useBiometricAuthenticationStackView.isHidden = !BiometricAuthentication.isAvailable
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tryEnableLoginButton()
        navigationBarColor = .white
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillChangeFrame(_:)),
                                               name: .UIKeyboardWillChangeFrame, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}
