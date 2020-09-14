//
//  DisConnectedView.swift
//  ESCore
//
//  Created by Eslam Hanafy on 12/10/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit
import SwiftyGif
import IBAnimatable

class DisConnectedView: UIView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var retryButton: AnimatableButton!
    
    
    
    
    static func getInstance(for owner: AnyObject) -> DisConnectedView {
        return (bundle(for: owner).loadNibNamed("DisConnectedView", owner: owner, options: nil)?.last as! DisConnectedView)
    }

    
    
    
    func configure(with settings: ESConnectivitySettings) {
        apply(settings)
        
        switch settings.alertType {
        case .fullscreenWithImage:
            displayImage(settings.disconnectedImage)
            
        default:
            displayGIFImage(settings.disconnectedImage)
        }
    }
    
    
    
    //MARK: - IBActions
    @IBAction func retryAction() {
        retryButton.isEnabled = false
        ESConnectivityManager.shared.checkConnectivity { [weak self] (_) in
            self?.retryButton.isEnabled = true
        }
    }
}

//MARK: - Helpers
private extension DisConnectedView {
    func displayImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    func displayGIFImage(_ image: UIImage?) {
        if let image = image {
            imageView.setGifImage(image)
        } else {
            let data = try! Data(contentsOf: URL(fileURLWithPath: bundle(for: self).path(forResource: "cryImage.gif", ofType: nil)!))
            imageView.setGifImage(try! UIImage(gifData: data), loopCount: -1)
        }
        
        imageView.startAnimating()
    }
    
    func apply(_ settings: ESConnectivitySettings) {
        self.backgroundColor = settings.backgroundColor
        
        titleLabel.text = settings.titleText
        titleLabel.textColor = settings.titleTextColor
        titleLabel.font = settings.titleFont
        
        retryButton.isHidden = settings.hideRetryButton
        
        guard !retryButton.isHidden else { return }
        
        retryButton.titleLabel?.textColor = settings.retryButtonTextColor
        retryButton.setTitle(settings.retryButtonNormalText, for: .normal)
        retryButton.setTitle(settings.retryButtonDisabledText, for: .disabled)
        retryButton.backgroundColor = settings.retryButtonBackgroundColor
        retryButton.cornerRadius = settings.retryButtonCornerRadius
        retryButton.titleLabel?.font = settings.retryButtonFont
    }
}
