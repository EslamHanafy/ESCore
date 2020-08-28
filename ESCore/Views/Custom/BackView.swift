//
//  BackView.swift
//  EslamCore
//
//  Created by Eslam Hanafy on 11/19/17.
//  Copyright © 2017 Eslam. All rights reserved.
//

import UIKit

@IBDesignable
class BackView: ButtonView {
    private var isRotated:Bool = false
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.flip()
    }
 

    /// flip any view 180 degree in english language
    ///
    /// - Parameter view: any view to flip
    func flip(){
        if isRTL && !isRotated {
            isRotated = true
            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
    }
}
