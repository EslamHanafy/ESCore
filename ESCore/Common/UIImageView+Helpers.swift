//
//  UIImageView+Helpers.swift
//  ESCore
//
//  Created by Eslam Hanafy on 12/10/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit
import SDWebImage
import InitialsImageView

public extension UIImageView {
    func showImage() {
        guard let image = self.image else {
            return Log.warning("There are no images to be shown")
        }
        
        ImageViewer.show(image)
    }
    
    func loadImage(from: URL?, usingNameAsDefault name: String, circular: Bool = true) {
        if let url = from {
            self.sd_setImage(with: url, placeholderImage: UIImage(coreNamed: "avatar"))
        } else {
            self.setImageForName(name, circular: circular, textAttributes: nil)
        }
    }
}
