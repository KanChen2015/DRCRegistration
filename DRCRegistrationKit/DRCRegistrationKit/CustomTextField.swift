//
//  CustomTextField.swift
//  DRCRegistrationKit
//
//  Created by Kan Chen on 6/6/16.
//  Copyright © 2016 drchrono. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    let dx: CGFloat = 8.0
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, dx, 0)
    }

    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
}
