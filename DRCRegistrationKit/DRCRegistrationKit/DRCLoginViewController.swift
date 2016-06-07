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
    func drcLoginController(controller: DRCLoginViewController, didAttemptSignInWithUserName username: String, password: String, twoFactorCode: String, complete: (success: Bool, JSON: AnyObject, error: NSError?) -> Void)
    func drcLoginController(controller: DRCLoginViewController, didAttemptSignInWithPINCode PINCode: String)
}

class DRCLoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var credentialsHolderView: UIView!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!

    weak var delegate: DRCLoginViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        credentialsHolderView.layer.cornerRadius = 4.0
        credentialsHolderView.layer.borderColor = UIColor.lightGrayColor().CGColor
        credentialsHolderView.layer.borderWidth = 1.0
        credentialsHolderView.layer.masksToBounds = true
    }

    @IBAction func signInButtonClicked(sender: AnyObject) {
        guard let username = usernameTextField.text, password = passwordTextField.text else {
            return
        }
        loginActivityIndicator.startAnimating()
        delegate?.drcLoginController(self, didAttemptSignInWithUserName: username, password: password, twoFactorCode: "", complete: { (success, JSON, error) in
            self.loginActivityIndicator.stopAnimating()
            if let error = error {
                //TODO: error
                return
            }
            guard let json = JSON as? [String: AnyObject] else {
                //TODO: error
                return
            }
            let twoFactorRequired = "2-Factor Token Required" == json["login_errors"] as? String
            if success {
                self.delegate?.drcLoginControllerDidAuthenticateSuccess(self)
            } else if twoFactorRequired {
                //TODO Two Factor
            } else {

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
}
