//
//  Slider.swift
//  EslamCore
//
//  Created by Eslam Hanafy on 1/21/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit

@IBDesignable
open class Slider: UISlider {
    @IBInspectable public var trackHeight: CGFloat = 3

    @IBInspectable public var thumbRadius: CGFloat = 20

    @IBInspectable public var thumbBorderWidth: CGFloat = 1.0
    
    @IBInspectable public var thumbBorderColor: UIColor = .darkGray
    
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        let thumb = thumbImage(radius: thumbRadius)
        setThumbImage(thumb, for: .normal)
    }
    
    
    // Custom thumb view which will be converted to UIImage
    // and set as thumb. You can customize it's colors, border, etc.
    private lazy var thumbView: UIView = {
        let thumb = UIView()
        thumb.backgroundColor = thumbTintColor
        thumb.layer.borderWidth = thumbBorderWidth
        thumb.layer.borderColor = thumbBorderColor.cgColor
        return thumb
    }()

    override open func awakeFromNib() {
        super.awakeFromNib()
        let thumb = thumbImage(radius: thumbRadius)
        setThumbImage(thumb, for: .normal)
    }

    private func thumbImage(radius: CGFloat) -> UIImage {
        // Set proper frame
        // y: radius / 2 will correctly offset the thumb

        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2

        // Convert thumbView to UIImage
        // See this: https://stackoverflow.com/a/41288197/7235585

        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }

    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Set custom track height
        // As seen here: https://stackoverflow.com/a/49428606/7235585
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
}
