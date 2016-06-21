//
//  DRCPINCodeViewController.swift
//  DRCRegistrationKit
//
//  Created by Kan Chen on 6/20/16.
//  Copyright © 2016 drchrono. All rights reserved.
//

import UIKit
import LocalAuthentication

protocol DRCPINCodeViewControllerDelegate: class {
    func pinCodeControllerDidPassAuth(controller: DRCPINCodeViewController)
    func pinCodeController(controller: DRCPINCodeViewController, authenticateWithPIN PIN: String) -> Bool
}

class DRCPINCodeViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var PINCodeHolderView: UIStackView!
    @IBOutlet var PINCodes: [UILabel]!
    @IBOutlet weak var PINCodesInput: UITextField!
    @IBOutlet weak var touchIDButton: UIButton!
    weak var delegate: DRCPINCodeViewControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        touchIDButton.layer.cornerRadius = 22
        touchIDButton.layer.masksToBounds = true
        touchIDButton.layer.borderColor = UIColor.whiteColor().CGColor
        touchIDButton.layer.borderWidth = 1.0
        let context = LAContext()
        let enableTouchId = DelegateProvider.shared.networkingDelegate!.isTouchIDEnable
        touchIDButton.hidden = !(enableTouchId && context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: nil))
        PINCodesInput.delegate = self
        PINCodesInput.becomeFirstResponder()
    }

    // MARK: - UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.location == 4 { return false } //PINCode has only 4 digits
        return true
    }

    @IBAction func pincodeInputEditingChanged(sender: AnyObject) {
        updatePinLabelsUI()
        if PINCodesInput.text?.characters.count == 4 {
            authenticatePINCode(PINCodesInput.text ?? "")
        }
    }

    // MARK: - Actions
    func authenticateWithTouchID() {
        let context = LAContext()
        let prompt = "Unlock with your finger"
        var error: NSError?
        if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: prompt, reply: { success, error in
                dispatch_async(dispatch_get_main_queue()) {
                    if success {
                        self.delegate.pinCodeControllerDidPassAuth(self)
                    }
                }
            })
        }
    }


    func authenticatePINCode(pinCode: String) {
        if delegate.pinCodeController(self, authenticateWithPIN: pinCode) {
            delegate.pinCodeControllerDidPassAuth(self)
        } else {
            UIView.animateKeyframesWithDuration(0.625, delay: 0, options: [], animations: {
                UIView.setAnimationCurve(.Linear)
                let repeatCount = 8
                let duration: NSTimeInterval = 1.0 / Double(repeatCount)
                for i in 0..<repeatCount {
                    UIView.addKeyframeWithRelativeStartTime(duration * Double(i), relativeDuration: duration, animations: {
                        let dx: CGFloat = 5.0
                        if i == repeatCount - 1 {
                            self.PINCodeHolderView.transform = CGAffineTransformIdentity
                        } else if i % 2 == 1 {
                            self.PINCodeHolderView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -dx, 0)
                        } else {
                            self.PINCodeHolderView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, +dx, 0)
                        }
                    })
                }

                }, completion: { finished in
                    self.resetPINInput()
            })
        }
    }

    @IBAction func loginWithPasswordButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(false, completion: nil)
    }
    // MARK: - Misc
    private func updatePinLabelsUI() {
        let count = PINCodesInput.text?.characters.count ?? 0
        if count < 0 || count > 4 { return }
        for (index, label) in PINCodes.enumerate() {
            if index < count {
                label.text = "●"
            } else {
                label.text = "○"
            }
        }
    }

    private func resetPINInput() {
        PINCodesInput.text = ""
        updatePinLabelsUI()
    }
}
