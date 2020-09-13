//
//  DPDataSource.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/4/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation

open class DPDataSource {
    open var screenTitle: String
    open var items: [String: [ESDataPickerItemType]]
    open var preferredSection: ESDataPickerPreferredSection?
    
    public init (screenTitle: String, items: [String: [ESDataPickerItemType]], preferredSection: ESDataPickerPreferredSection? = nil) {
        self.screenTitle = screenTitle
        self.items = items
        self.preferredSection = preferredSection
    }
}
