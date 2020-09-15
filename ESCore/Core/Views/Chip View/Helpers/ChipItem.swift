//
//  ChipItem.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/2/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation

open class ESChipItem: ESChipItemType {
    open var title: String = ""
    open var status: ESChipItemStatus = .none
    
    public init(title: String, status: ESChipItemStatus = .none) {
        self.title = title
        self.status = status
    }
}

//MARK: - Equatable
extension ESChipItem: Equatable {
    public static func == (lhs: ESChipItem, rhs: ESChipItem) -> Bool {
        return lhs.title == rhs.title
    }
}
