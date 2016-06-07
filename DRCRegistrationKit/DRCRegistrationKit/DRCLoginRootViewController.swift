//
//  DRCLoginRootViewController.swift
//  DRCRegistrationKit
//
//  Created by Kan Chen on 6/6/16.
//  Copyright © 2016 drchrono. All rights reserved.
//

import UIKit

@objc public protocol DRCLoginRootViewControllerDelegate {
    func drcLoginRootControllerDidAuthenticateSuccess(controller: DRCLoginRootViewController)
    func drcLoginRootController(controller: DRCLoginRootViewController, didAttemptSignInWithUsername username: String, password: String, twoFactorCode: String, complete: (success: Bool, JSON: AnyObject, error: NSError?) -> Void)
    func drcLoginRootController(controller: DRCLoginRootViewController, didAttemptSignInWithPINCode PINCode: String)
}

public class DRCLoginRootViewController: UIViewController {
    static public func instantiateFromStoryBoard() -> DRCLoginRootViewController {
        let storyboard = UIStoryboard(name: "DRCLogin", bundle: NSBundle(forClass: self))
        guard let vc = storyboard.instantiateViewControllerWithIdentifier("LoginRoot") as? DRCLoginRootViewController else {
            fatalError("failed to init from storyboard")
        }
        return vc
    }
    weak var delegate: DRCLoginRootViewControllerDelegate?
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let pageController = segue.destinationViewController as? DRCLoginPageViewController where segue.identifier == "embedPageView" {
            pageController.loginDelegate = self
        }
    }

}

extension DRCLoginRootViewController: DRCLoginViewControllerDelegate {
    func drcLoginControllerDidAuthenticateSuccess(controller: DRCLoginViewController) {
        delegate?.drcLoginRootControllerDidAuthenticateSuccess(self)
    }

    func drcLoginController(controller: DRCLoginViewController, didAttemptSignInWithPINCode PINCode: String) {
        delegate?.drcLoginRootController(self, didAttemptSignInWithPINCode: PINCode)
    }

    func drcLoginController(controller: DRCLoginViewController, didAttemptSignInWithUserName username: String, password: String, twoFactorCode: String, complete: (success: Bool, JSON: AnyObject, error: NSError?) -> Void) {
        delegate?.drcLoginRootController(self, didAttemptSignInWithUsername: username, password: password, twoFactorCode: twoFactorCode, complete: complete)
    }
}
