//
//  ESButton.swift
//  ESCore
//
//  Created by Eslam on 1/10/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import IBAnimatable

@IBDesignable
open class ESButton: AnimatableButton {
    @IBInspectable open var customFont: String = "main" {
        didSet {
            self.titleLabel?.font = Fonts.font(for: customFont)
        }
    }
    
    @IBInspectable open var lines: Int = 1 {
        didSet {
            self.titleLabel?.numberOfLines = lines
        }
    }
}

