//
//  Utility.swift
//  DRCRegistrationKit
//
//  Created by Kan Chen on 6/9/16.
//  Copyright © 2016 drchrono. All rights reserved.
//

import UIKit

internal let InputHolderBorderColor = UIColor.lightGrayColor()

internal extension UIView {
    func addBorderForInputContainerStyle() {
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = InputHolderBorderColor.CGColor
    }
}
