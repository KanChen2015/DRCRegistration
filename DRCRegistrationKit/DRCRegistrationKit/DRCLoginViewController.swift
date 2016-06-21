//
//  DRCLoginViewController.swift
//  DRCRegistrationKit
//
//  Created by Kan Chen on 6/6/16.
//  Copyright © 2016 drchrono. All rights reserved.
//

import UIKit

protocol DRCLoginViewControllerDelegate: class {
    func drcLoginControllerDidAuthenticateSuccess(controller: DRCLoginViewController)
    func drcLoginController(controller: DRCLoginViewController, didAttemptSignInWithUserName username: String, password: String, twoFactorCode: String, complete: (success: Bool, twoFactorRequired: Bool, error: NSError?) -> Void)
    func drcLoginController(controller: DRCLoginViewController, didAttemptSignInWithPINCode PINCode: String) -> Bool
}

class DRCLoginViewController: UIViewController {
    private let signupSegueId = "startSignUp"
    @IBOutlet weak var usernameTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var credentialsHolderView: UIView!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!

    weak var delegate: DRCLoginViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        credentialsHolderView.addBorderForInputContainerStyle()
    }

    @IBAction func signInButtonClicked(sender: AnyObject) {
        guard let username = usernameTextField.text, password = passwordTextField.text else {
            return
        }
        loginActivityIndicator.startAnimating()
        delegate?.drcLoginController(self, didAttemptSignInWithUserName: username, password: password, twoFactorCode: "", complete: { (success, twoFactorRequired, error) in
            dispatch_async(dispatch_get_main_queue()) {
                self.loginActivityIndicator.stopAnimating()
                if let error = error {
                    //TODO: error
                    return
                }
                if success {
                    self.delegate?.drcLoginControllerDidAuthenticateSuccess(self)
                } else if twoFactorRequired {
                    //two Factor Step Yes
                    //show authy field
                } else {
                    // error
                    // change the
                }

            }
        })
    }

    func touchIdSuccess() {
        delegate?.drcLoginControllerDidAuthenticateSuccess(self)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        view.endEditing(true)
    }

    private func validateInput() -> Bool {
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startSignUp" {
            (segue.destinationViewController as? DRRSignUpNavigationController)?.signUpDelegate = self
        } else if segue.identifier == "displayPINCodeView" {
            (segue.destinationViewController as? DRCPINCodeViewController)?.delegate = self
        }
    }
}

extension DRCLoginViewController: DRRSignUPNavigationControllerDelegate {
    func signupController(controller: DRRSignUpNavigationController, didSuccessSignUpWithUsername username: String, password: String) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        usernameTextField.text = username
        passwordTextField.text = password
        signInButtonClicked(self)
    }
}

extension DRCLoginViewController: DRCPINCodeViewControllerDelegate {
    func pinCodeController(controller: DRCPINCodeViewController, authenticateWithPIN PIN: String) -> Bool {
        return delegate?.drcLoginController(self, didAttemptSignInWithPINCode: PIN) ?? false
    }
    func pinCodeControllerDidPassAuth(controller: DRCPINCodeViewController) {
        dismissViewControllerAnimated(false) { 
            self.delegate?.drcLoginControllerDidAuthenticateSuccess(self)
        }
    }
}
