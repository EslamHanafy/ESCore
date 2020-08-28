//
//  ShadowView.swift
//  EslamCore
//
//  Created by Eslam Hanafy on 11/19/17.
//  Copyright © 2017 Eslam. All rights reserved.
//

import UIKit

@IBDesignable
class CustomView: UIView {
    //shadow
    @IBInspectable var drawShadow:Bool = false
    @IBInspectable var shadowColor:UIColor = .black
    @IBInspectable var shadowOffset:CGSize = CGSize.zero
    @IBInspectable var shadowRadius:CGFloat = 1.0
    @IBInspectable var shadowOpacity:CGFloat = 1.0
    //border
    @IBInspectable var drawBorder:Bool = false
    @IBInspectable var borderRadius:CGFloat = 0.0
    @IBInspectable var borderColor:UIColor = .clear
    @IBInspectable var borderWidth:CGFloat = 0.0
    /// determine if should use percentage to calculat the corner radius or not
    @IBInspectable var usePercentage:Bool = true
    @IBInspectable var maskToBounds:Bool = false
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if drawBorder {
            drawBorder(forRect: rect)
        }
        
        if drawShadow {
            drawShadow(forRect: rect)
        }
        
        self.layer.masksToBounds = maskToBounds
    }
    
    
    /// draw shadow for the view
    ///
    /// - Parameter rect: current rect for the view
    func drawShadow(forRect rect:CGRect) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = Float(shadowOpacity)
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowPath = drawBorder ? UIBezierPath(roundedRect: rect, cornerRadius: self.layer.cornerRadius).cgPath : UIBezierPath(rect: rect).cgPath
    }
    
    /// draw borders for the view
    ///
    /// - Parameter rect: current rect for the view
    func drawBorder(forRect rect:CGRect) {
        self.layer.cornerRadius = usePercentage ? rect.height * borderRadius : borderRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    
}
