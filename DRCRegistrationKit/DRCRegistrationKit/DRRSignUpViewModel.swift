//
//  DRRSignUpViewModel.swift
//  DRCRegistrationKit
//
//  Created by Kan Chen on 6/8/16.
//  Copyright © 2016 drchrono. All rights reserved.
//

import Foundation

internal let kDRRSignupFullNameKey = "name"
internal let kDRRSignupFirstNameKey = "firstName"
internal let kDRRSignupLastNameKey = "lastName"
internal let kDRRSignupEmailKey = "email"
internal let kDRRSignupPhoneKey = "office_phone"
internal let kDRRSignupSessionKey = "signup_session"
//step 2
internal let kDRRSignupStateKey = "state"
internal let kDRRSignupSpecialtyKey = "specialty"
internal let kDRRSignupJobTitleKey = "job_title"
//step 3
internal let kDRRSignupUsernameKey = "username"
internal let kDRRSignupPasswordKey = "password"
internal let kDRRSignupPasswordConfirmKey = "password_confirm"
internal let kDRRSignupTermsConfirmedKey = "terms_of_service_agreement"
//#define kDRCSignupBillingKey @"billing"
//#define kDRCSignupProvidersKey @"providers"
//#define kDRCSignupTermsKey @""
//#define kPracticeSizeDisplays @[@"Just Me", @"2 to 5", @"6 to 10", @"10+"]
//#define kBillingTypeDisplays @[@"Insurance", @"Cash-based"]

final class DRRSignUpViewModel {
    typealias signupStepComplete = (success: Bool, errorMsg: String?) -> Void
    var delegate: DRCRegistrationNetworkingDelegate? = DelegateProvider.shared.networkingDelegate
    var stateChoices: [String] = []
    var jobTitleChoices: [String] = []
    var specialtyChoices: [String] = []
    private var signupSession: String = ""
    var registeredUsername: String = ""
    var registeredPassword: String = ""
    func signupStep1WithInfo(info: [String: AnyObject], complete: signupStepComplete) {
        delegate?.attemptSignupStep1RequestWithInfo(info, complete: { (json, error) in
            if let error = error {
                complete(success: false, errorMsg: error.localizedDescription)
                return
            }
            if let success = json["success"] as? Bool where success {
                self.signupSession = json[kDRRSignupSessionKey] as? String ?? ""
                self.stateChoices = json["state_choices"] as? [String] ?? []
                self.jobTitleChoices = json["job_title_choices"] as? [String] ?? []
                self.specialtyChoices = json["specialty_choices"] as? [String] ?? []
                complete(success: true, errorMsg: nil)
            } else {
                complete(success: false, errorMsg: json["errors"] as? String)
            }
        })
    }

    func signupStep2WithInfo(info: [String: AnyObject], complete: signupStepComplete) {
        var finalInfo = info
        finalInfo[kDRRSignupSessionKey] = signupSession
        delegate?.attemptSignupStep2RequestWithInfo(finalInfo, complete: { (json, error) in
            if let error = error {
                complete(success: false, errorMsg: error.localizedDescription)
                return
            }
            if let success = json["success"] as? Bool where success {
                complete(success: true, errorMsg: nil)
            } else {
                complete(success: false, errorMsg: json["errors"] as? String)
            }
        })
    }

    func signupStep3WithInfo(info: [String: AnyObject], complete: signupStepComplete) {
        var finalInfo = info
        finalInfo[kDRRSignupSessionKey] = signupSession
        //TODO: does this is required by our backend?
        finalInfo[kDRRSignupTermsConfirmedKey] = true
        delegate?.attemptSignupStep3RequestWithInfo(finalInfo, complete: { (json, error) in
            if let error = error {
                complete(success: false, errorMsg: error.localizedDescription)
                return
            }
            if let success = json["success"] as? Bool where success {
                guard let
                    registeredUsername = json["username"] as? String,
                    registeredPassword = json["password"] as? String
                where !registeredUsername.isEmpty && !registeredPassword.isEmpty else {
                    complete(success: false, errorMsg: "An unknown error happened, please try again later")
                    return
                }
                self.registeredUsername = registeredUsername
                self.registeredPassword = registeredPassword
                //TODO: PIN Manager
                complete(success: true, errorMsg: nil)

            } else {
                complete(success: false, errorMsg: json["errors"] as? String)
            }
        })
    }
}
