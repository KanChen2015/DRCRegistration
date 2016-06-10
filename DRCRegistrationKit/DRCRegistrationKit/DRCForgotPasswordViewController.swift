//
//  DRCForgotPasswordViewController.swift
//  DRCRegistrationKit
//
//  Created by Kan Chen on 6/10/16.
//  Copyright © 2016 drchrono. All rights reserved.
//

import UIKit

class DRCForgotPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var submitButton: UIButton!

    @IBAction func submitButtonClicked(sender: AnyObject) {
        guard let email = emailTextField.text else { return }
        spinner.startAnimating()
        DelegateProvider.shared.networkingDelegate?.forgotPasswordWithEmail(email, complete: { success in
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                self?.spinner.stopAnimating()
                let title = success ? "Request Accepted" : "Request Failed"
                let msg = success ? "Please check your email for further instruction." : "Please try again later."
                let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { action in
                    if success { self?.dismissViewControllerAnimated(true, completion: nil) }
                }))
                self?.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }

    @IBAction func emailTextFieldEditingChanged(sender: AnyObject) {
        if validEmail(emailTextField.text) {
            emailTextField.backgroundColor = UIColor(red: 230/255.0, green: 245/255.0, blue: 220/255.0, alpha: 1.0)
            submitButton.enabled = true
        } else {
            submitButton.enabled = false
            emailTextField.backgroundColor = UIColor.whiteColor()
        }
    }

    @IBAction func cancelButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(false, completion: nil)
    }

    private func validEmail(email: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email)
    }
}
