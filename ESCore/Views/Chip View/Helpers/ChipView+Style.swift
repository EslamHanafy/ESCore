//
//  ChipView+Style.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/2/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation

public extension ChipView {
    class Style {
        public var normalFont: UIFont = .systemFont(ofSize: 14)
        public var normalColor: UIColor = .clear
        public var normalFontColor: UIColor = .black
        public var normalBorderColor: UIColor = .black
        
        public var selectedFont: UIFont = .systemFont(ofSize: 14)
        public var selectedColor: UIColor = .blue
        public var selectedFontColor: UIColor = .white
        public var selectedBorderColor: UIColor = .white
        
        public var disableFont: UIFont = .systemFont(ofSize: 14)
        public var disabledColor: UIColor = .clear
        public var disabledBorderColor: UIColor = .lightGray
        public var disabledFontColot: UIColor = .lightGray
        
        public var maxItemWidth: CGFloat = 0
    }
}
