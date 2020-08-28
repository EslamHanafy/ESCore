//
//  GenderView.swift
//  ESCore
//
//  Created by Eslam Hanafy on 12/22/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation
import IBAnimatable

open class GenderView: UIView {
    @IBOutlet open var maleImageView: AnimatableImageView!
    @IBOutlet open var femaleImageView: AnimatableImageView!
    
    public private(set) var gender: String = "male"
    
    private let selectedImage: UIImage? = UIImage(named: "radio-button-on")
    
    
    @IBAction public func maleAction() {
        setGender(isMale: true)
    }
    
    @IBAction public func femaleAction() {
        setGender(isMale: false)
    }
}

//MARK: - Helpers
public extension GenderView {
    func setGender(isMale: Bool) {
        if isMale {
            maleImageView.image = selectedImage
            maleImageView.borderWidth = 0
            femaleImageView.image = nil
            femaleImageView.borderWidth = 2
            gender = "male"
        } else {
            femaleImageView.image = selectedImage
            femaleImageView.borderWidth = 0
            maleImageView.image = nil
            maleImageView.borderWidth = 2
            gender = "female"
        }
    }
    
    func setGender(_ gender: String) {
        setGender(isMale: gender == "male")
    }
}
