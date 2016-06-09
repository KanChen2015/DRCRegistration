//
//  DRRSignUpNavigationController.swift
//  DRCRegistrationKit
//
//  Created by Kan Chen on 6/9/16.
//  Copyright © 2016 drchrono. All rights reserved.
//

import UIKit

protocol DRRSignUPNavigationControllerDelegate: class {
    func signupController(controller: DRRSignUpNavigationController, didSuccessSignUpWithUsername username: String, password: String)
}

class DRRSignUpNavigationController: UINavigationController {
    weak var signUpDelegate: DRRSignUPNavigationControllerDelegate?
}
