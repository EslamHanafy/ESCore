//
//  ESTextField.swift
//  ESCore
//
//  Created by Eslam on 1/10/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit
import IBAnimatable

@IBDesignable
open class ESTextField: AnimatableTextField {
    @IBInspectable open var customFont: String = "main" {
        didSet {
            self.font = Fonts.font(for: customFont)
        }
    }
}
