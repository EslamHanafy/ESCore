//
//  DataPickerPreferredSection.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/4/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation

open class DataPickerPreferredSection {
    public var title: String
    public var items: [DataPickerItemType]
    
    public init(title: String, items: [DataPickerItemType]) {
        self.title = title
        self.items = items
    }
}
