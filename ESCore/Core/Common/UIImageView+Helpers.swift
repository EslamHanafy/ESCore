//
//  UIImageView+Helpers.swift
//  ESCore
//
//  Created by Eslam Hanafy on 12/10/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit
import SDWebImage

public extension UIImageView {
    func showImage() {
        guard let image = self.image else {
            return Log.warning("There are no images to be shown")
        }
        
        ESImageViewer.shared.show(image)
    }
    
    func loadImage(from: URL?, withDefaults defaults: ESDefaults = .image(UIImage(coreNamed: "avatar")), circular: Bool = true) {
        switch defaults {
        case .image(let image):
            self.sd_setImage(with: from, placeholderImage: image)
            
        case .name(let name, let color):
            if let name = name {
                self.sd_setImage(with: from, placeholderImage: self.esGetImageForName(name, backgroundColor: color, circular: circular))
            } else {
                self.sd_setImage(with: from)
            }
        }
    }
}

public extension UIImageView {
    enum ESDefaults {
        case image(_ image: UIImage?)
        case name(_ text: String?, background: UIColor? = nil)
    }
}
