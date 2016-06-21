//
//  DRROnPatientLinkViewController.swift
//  DRCRegistrationKit
//
//  Created by Kan Chen on 6/20/16.
//  Copyright © 2016 drchrono. All rights reserved.
//

import UIKit

class DRROnPatientLinkViewController: UIViewController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    @IBAction func cancelButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func downloadOnPatientClicked(sender: AnyObject) {
        if let url = NSURL(string: "https://itunes.apple.com/us/app/onpatient-personal-health/id577198251?mt=8") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}
