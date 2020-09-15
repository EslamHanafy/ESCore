//
//  ESSegmentedControl.swift
//  ESCore
//
//  Created by Eslam on 1/10/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

@IBDesignable
open class ESSegmentedControl: UISegmentedControl {

    @IBInspectable open var customFont: String = "main" {
        didSet {
            let font = Fonts.font(for: customFont)
            self.setTitleTextAttributes([NSAttributedString.Key.font : font], for: .normal)
            self.setTitleTextAttributes([NSAttributedString.Key.font : font], for: .highlighted)
            self.setTitleTextAttributes([NSAttributedString.Key.font : font], for: .selected)
        }
    }
    
}
