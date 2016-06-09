//
//  DRRSignUpStep1.swift
//  DRCRegistrationKit
//
//  Created by Kan Chen on 6/8/16.
//  Copyright © 2016 drchrono. All rights reserved.
//

import UIKit

class DRRSignUpStep1: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var inputContainerView: UIView!
    private var viewModel = DRRSignUpViewModel()
    private let step2SegueId = "gotoStepTwo"
    override func viewDidLoad() {
        super.viewDidLoad()
        inputContainerView.addBorderForInputContainerStyle()
    }

    @IBAction func nextButtonClicked(sender: AnyObject) {
        var parameters: [String: AnyObject] = [:]
        parameters[kDRRSignupFullNameKey] = nameTextField.text
        parameters[kDRRSignupPhoneKey] = phoneNumberTextField.text
        parameters[kDRRSignupEmailKey] = emailTextField.text
        spinner.startAnimating()
        viewModel.signupStep1WithInfo(parameters) { (success, errorMsg) in
            dispatch_async(dispatch_get_main_queue()) {
                self.spinner.stopAnimating()
                if success {
                    self.performSegueWithIdentifier(self.step2SegueId, sender: self)
                } else {
                    let alert = UIAlertController(title: nil, message: errorMsg, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: false, completion: nil)
                }
            }
        }
    }

    @IBAction func cancelButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        view.endEditing(true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == step2SegueId {
            (segue.destinationViewController as? DRRSignUpStep2)?.viewModel = viewModel
        }
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            phoneNumberTextField.becomeFirstResponder()
        case phoneNumberTextField:
            emailTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
