//
//  ChipItem.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/2/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation

open class ChipItem: ChipItemType {
    open var title: String = ""
    open var status: ChipItemStatus = .none
    
    public init(title: String, status: ChipItemStatus = .none) {
        self.title = title
        self.status = status
    }
}

//MARK: - Equatable
extension ChipItem: Equatable {
    public static func == (lhs: ChipItem, rhs: ChipItem) -> Bool {
        return lhs.title == rhs.title
    }
}
