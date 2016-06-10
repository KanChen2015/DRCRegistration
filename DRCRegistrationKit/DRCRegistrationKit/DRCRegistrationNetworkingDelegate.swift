//
//  DRCRegistrationNetworkingDelegate.swift
//  DRCRegistrationKit
//
//  Created by Kan Chen on 6/10/16.
//  Copyright © 2016 drchrono. All rights reserved.
//

import Foundation

@objc public protocol DRCRegistrationNetworkingDelegate {
    func attemptSignupStep1RequestWithInfo(info: [String: AnyObject], complete: (json: [String: AnyObject], error: NSError?) -> Void)
    func attemptSignupStep2RequestWithInfo(info: [String: AnyObject], complete: (json: [String: AnyObject], error: NSError?) -> Void)
    func attemptSignupStep3RequestWithInfo(info: [String: AnyObject], complete: (json: [String: AnyObject], error: NSError?) -> Void)
    func forgotPasswordWithEmail(email: String, complete: (success: Bool) -> Void)
}