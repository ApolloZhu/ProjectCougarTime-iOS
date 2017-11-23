//
//  StudentIDInputContainerViewController.swift
//  ProjectCougarTime-iOS-Teacher
//
//  Created by Apollo Zhu on 11/8/17.
//  Copyright © 2017 Oakton High School. All rights reserved.
//

import UIKit
import Foundation

class StudentIDInputContainerViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBarColor = arc4random_uniform(2) < 1 ? .burgundy : .gold
    }
    
    private var currentInputMethodIndex = 0 {
        didSet {
            guard oldValue != currentInputMethodIndex else { return }
            cycle(from: inputViewControllers[oldValue],
                  to: inputViewControllers[currentInputMethodIndex])
        }
    }
    
    private func cycle(from oldVC: UIViewController, to newVC: UIViewController) {
        // Prepare the two view controllers for the change.
        oldVC.willMove(toParentViewController: nil)
        addChildViewController(newVC)
        
        // Get the start frame of the new view controller and the end frame
        // for the old view controller. Both rectangles are offscreen.
        newVC.view.alpha = 0
        
        // Queue up the transition animation.
        transition(from: oldVC, to: newVC, duration: 0.25, options: .curveEaseInOut,
                   animations: { [weak self] in
                    newVC.view.frame = oldVC.view.frame
                    newVC.view.alpha = 1
                    oldVC.view.alpha = 0
                    self?.embedView(newVC.view) },
                   completion: { [weak self] _ in
                    oldVC.removeFromParentViewController()
                    guard let this = self else { return }
                    newVC.didMove(toParentViewController: this) })
    }
    
    private func embedView(_ childView: UIView) {
        containerView.addSubview(childView)
        childView.constraintToSuperview()
    }
    
    private lazy var inputViewControllers =
        StudentIDInputViewControllerTypes.flatMap
            { $0.self.isSupported ? $0.instantiate() : nil }
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.constraintToSuperview()
            let firstVC = inputViewControllers[0]
            addChildViewController(firstVC)
            embedView(firstVC.view)
            firstVC.didMove(toParentViewController: self)
        }
    }
    
    @IBOutlet weak var switchInputMethodButton: UIBarButtonItem! {
        didSet {
            switchInputMethodButton.isEnabled = inputViewControllers.count > 1
        }
    }
    
    @IBAction func switchInputMethod() {
        let prefix = NSLocalizedStringPrefix()
        let alert = UIAlertController(
            title: NSLocalizedString(
                "\(prefix).alert.title",
                value: "Switch to",
                comment: ""),
            message: NSLocalizedString(
                "\(prefix).alert.message",
                value: "Input Student ID using",
                comment: ""),
            preferredStyle: .actionSheet)
        for (index, method) in inputViewControllers.enumerated() {
            alert.addAction(UIAlertAction(
                title: type(of: method).localizedName,
                style: .default,
                handler: { [weak self] _ in
                    self?.currentInputMethodIndex = index
            }))
        }
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func done() {
        
    }
}
