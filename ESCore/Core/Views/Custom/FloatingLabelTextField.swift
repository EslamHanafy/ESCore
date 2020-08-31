//
//  FloatingLabelTextField.swift
//  ESCore
//
//  Created by Eslam on 12/21/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation
import SkyFloatingLabelTextField

open class FloatingLabelTextField: SkyFloatingLabelTextField {
    @IBInspectable open var alwaysDisplayTitle: Bool = false {
        didSet {
            self.setTitleVisible(alwaysDisplayTitle)
        }
    }
    
    @IBInspectable open var _titleFont: String? = nil {
        didSet {
            if let fon = _titleFont {
                self.titleFont = UIFont(name: fon, size: _titleFontSize) ?? UIFont.systemFont(ofSize: _titleFontSize)
            }
        }
    }
    
    @IBInspectable open var _titleFontSize: CGFloat = 15 {
        didSet {
            if let fon = _titleFont {
                self.titleFont = UIFont(name: fon, size: _titleFontSize) ?? UIFont.systemFont(ofSize: _titleFontSize)
            }
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
