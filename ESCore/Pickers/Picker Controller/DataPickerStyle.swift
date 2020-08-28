//
//  DataPickerStyle.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/4/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit

open class DataPickerStyle {
    open var itemTextColor: UIColor = .black
    open var itemFont: UIFont = .systemFont(ofSize: 15)
    open var itemImageSize: CGSize = CGSize(width: 24, height: 24)
    open var itemImageCornerRadius: CGFloat = 0
    open var showCheckMark: Bool = true
    open var sectionTitleFont: UIFont = .systemFont(ofSize: 17)
    open var sectionTitleTextColor: UIColor = .black
    open var showSectionIndexTitles: Bool = false
    
    public init () {  }
}
