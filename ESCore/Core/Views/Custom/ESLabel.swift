//
//  ESLabel.swift
//  ESCore
//
//  Created by Eslam on 1/10/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import IBAnimatable

@IBDesignable
open class ESLabel: AnimatableLabel {
    @IBInspectable open var customFont: String = "main" {
        didSet {
            self.font = Fonts.font(for: customFont)
        }
    }
}
