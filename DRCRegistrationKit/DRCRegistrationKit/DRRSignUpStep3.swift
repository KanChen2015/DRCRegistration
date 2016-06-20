//
//  DRRSignUpStep3.swift
//  DRCRegistrationKit
//
//  Created by Kan Chen on 6/9/16.
//  Copyright © 2016 drchrono. All rights reserved.
//

import UIKit

class DRRSignUpStep3: UIViewController {
    var viewModel: DRRSignUpViewModel!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var usernameTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var confirmPasswordTextField: CustomTextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        inputContainerView.addBorderForInputContainerStyle()
    }

    @IBAction func signUpButtonClcked(sender: AnyObject) {
        var parameters: [String: AnyObject] = [:]
        parameters[kDRRSignupUsernameKey] = usernameTextField.text
        parameters[kDRRSignupPasswordKey] = passwordTextField.text
        parameters[kDRRSignupPasswordConfirmKey] = confirmPasswordTextField.text
        spinner.startAnimating()
        viewModel.signupStep3WithInfo(parameters) { (success, errorMsg) in
            dispatch_async(dispatch_get_main_queue()) {
                self.spinner.stopAnimating()
                if success {
                    guard let signupNavigationController = self.navigationController as? DRRSignUpNavigationController else { return }
                    signupNavigationController.signUpDelegate?.signupController(signupNavigationController,
                        didSuccessSignUpWithUsername: self.viewModel.registeredUsername,
                        password: self.viewModel.registeredPassword)
                } else {
                    let alert = UIAlertController(title: nil, message: errorMsg, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: false, completion: nil)
                }
            }
        }
    }

}
