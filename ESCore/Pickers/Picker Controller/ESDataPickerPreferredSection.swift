//
//  ESDataPickerPreferredSection.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/4/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation

open class ESDataPickerPreferredSection {
    public var title: String
    public var items: [ESDataPickerItemType]
    
    public init(title: String, items: [ESDataPickerItemType]) {
        self.title = title
        self.items = items
    }
}
