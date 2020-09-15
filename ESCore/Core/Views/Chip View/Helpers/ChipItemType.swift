//
//  ChipItemType.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/5/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation

public protocol ESChipItemType {
    var title: String { get }
    var status: ESChipItemStatus { get set }
}
