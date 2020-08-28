//
//  UIImage+Helpers.swift
//  EslamCore
//
//  Created by Eslam on 1/14/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

public extension UIImage {
    var base64String: String {
        let imageData = self.jpegData(compressionQuality: 0.5)
        return  (imageData?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)) ?? ""
    }
}

// MARK: - Methods
public extension UIImage {
    @discardableResult
    func store(withName name: String, at folder: String) -> URL? {
        if let data = jpegData(compressionQuality: 0.7) {
            return FileManager.store(fileData: data, withName: name + ".jpg", atFolder: folder)
        }
        
        return nil
    }
    
    func show(from: UIImageView? = nil) {
        ImageViewer.show(self)
    }
}

// MARK: - Initializers
public extension UIImage {
    convenience init?(coreNamed: String) {
        self.init(named: coreNamed, in: currentBundle, compatibleWith: nil)
    }
}
