//
//  PopupView.swift
//  EslamCore
//
//  Created by Eslam on 12/16/18.
//  Copyright © 2018 Eslam. All rights reserved.
//

import IBAnimatable

open class PopupView: UIView {
    @IBOutlet open var container: AnimatableView!
    
    public var animationDuration: TimeInterval = 0.8
    
    public weak var controller: UIViewController?
    
    public var hideOnOutTouches: Bool = true
    
    open func initFor(controller: UIViewController) {
        self.controller = controller
        
        self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.isHidden = true
        controller.view.addSubview(self)
    }
    
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, hideOnOutTouches {
            if !container.bounds.contains(touch.location(in: container)) {
                self.hideAnimation()
            }
        }
    }
}

//MARK: - Animations
public extension PopupView {
    
    /// show the view with animations
    func showAnimation() {
        self.isHidden = false
        UIApplication.shared.keyWindow?.bringSubviewToFront(self)
        container.animate(.slideFade(way: .in, direction: .up), duration: animationDuration)
    }
    
    
    /// hide the view with animations
    ///
    /// - Parameter onComplete: closure that called when finishing the animation
    func hideAnimation(_ onComplete: (() -> ())? = nil) {
        UIView.animate(withDuration: animationDuration * 0.5, animations: { [weak self] in
            guard let self = self else { return }
            self.alpha = 0.01
        }) { [weak self] (finished) in
            guard let self = self else { return }
            if finished {
                self.isHidden = finished
                self.alpha = 1
                onComplete?()
            }
        }
    }
    
}
