//
//  ESProgressView.swift
//  EslamCore
//
//  Created by Eslam Hanafy on 1/28/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit

@IBDesignable
open class ESProgressView: UIProgressView {
    @IBInspectable open var progressBarHeight: CGFloat = 2.0 {
        didSet {
            let transform = CGAffineTransform(scaleX: 1.0, y: progressBarHeight)
            self.transform = transform
        }
    }
}
