//
//  ESButtonView.swift
//  EslamCore
//
//  Created by Eslam on 4/12/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

@IBDesignable
open class ESButtonView: UIButton {
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
    
    @IBInspectable open var useRenderMode: Bool = false {
        didSet {
            updateImageView()
        }
    }
    
    @IBInspectable open var renderColor: UIColor = .white {
        didSet {
            _imageView.tintColor = renderColor
            updateImageView()
        }
    }
    
    @IBInspectable open var image: UIImage? = nil {
        didSet {
            updateImageView()
        }
    }
    
     @IBInspectable open var sizeMultiplier: CGFloat = 0.37 {
        didSet {
            if sizeMultiplier == 0 || sizeMultiplier > 1.0 {
                sizeMultiplier = oldValue
            }
        }
    }
    
    
    //shadow
    @IBInspectable public var drawShadow:Bool = false
    @IBInspectable public var shadowColor:UIColor = .black
    @IBInspectable public var shadowOffset:CGSize = CGSize.zero
    @IBInspectable public var shadowRadius:CGFloat = 1.0
    @IBInspectable public var shadowOpacity:CGFloat = 1.0
    
    //border
    @IBInspectable public var drawBorder:Bool = false
    @IBInspectable public var borderRadius:CGFloat = 0.0
    @IBInspectable public var borderColor:UIColor = .clear
    @IBInspectable public var borderWidth:CGFloat = 0.0
    
    /// determine if should use percentage to calculat the corner radius or not
    @IBInspectable public var usePercentage:Bool = true
    @IBInspectable public var maskToBounds:Bool = false
    
    
    
    private lazy var _imageView: UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        view.image = image
        view.contentMode = .scaleAspectFit
        self.addSubview(view)
        return view
    }()
    
    
    override public func draw(_ rect: CGRect) {
        prepareImageView(withRect: rect)
        
        if drawBorder {
            drawBorder(forRect: rect)
        }
        
        if drawShadow {
            drawShadow(forRect: rect)
        }
        
        self.layer.masksToBounds = maskToBounds
    }
    
    
    func setImageWithAnimation(_ image: UIImage?, duration: TimeInterval = 0.35) {
        self.image = image
        _imageView.fadeTransition(withDuration: duration)
    }
}

//MARK: - Helpers
private extension ESButtonView {
    func prepareImageView(withRect rect: CGRect) {
        let size = rect.height * sizeMultiplier
        _imageView.frame.size = CGSize(width: size, height: size)
        _imageView.center = CGPoint(x: rect.midX, y: rect.midY)
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
    
    func updateImageView() {
        if useRenderMode {
            _imageView.image = image?.withRenderingMode(.alwaysTemplate)
            _imageView.tintColor = renderColor
        } else {
            _imageView.image = image
        }
    }
}
