//
//  ESFloatingLabelTextField.swift
//  ESCore
//
//  Created by Eslam on 12/21/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation
import SkyFloatingLabelTextField

open class ESFloatingLabelTextField: SkyFloatingLabelTextField {
    @IBInspectable open var alwaysDisplayTitle: Bool = false {
        didSet {
            self.setTitleVisible(alwaysDisplayTitle)
        }
    }
    
    @IBInspectable open var customFont: String = "main" {
        didSet {
            self.font = Fonts.font(for: customFont)
        }
    }
    
    @IBInspectable open var customTitleFont: String = "main" {
        didSet {
            self.titleFont = Fonts.font(for: customFont)
        }
    }
    
    
    override open var titleFormatter: ((String) -> String) {
        get {
            return _titleFormatter
        }
        set {
            
        }
    }
    
    private var _titleFormatter: (String) -> String = { (text: String) -> String in
        return text
    }
}
