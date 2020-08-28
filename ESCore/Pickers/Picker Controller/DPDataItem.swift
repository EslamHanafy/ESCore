//
//  DPDataItem.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/4/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation

open class DPDataItem: DataPickerItemType {
    open var title: String
    open var image: UIImage?
    
    public init(title: String, image: UIImage? = nil) {
        self.title = title
        self.image = image
    }
}
