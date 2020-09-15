//
//  ESFont.swift
//  ESCore
//
//  Created by Eslam Hanafy on 9/15/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit

public struct ESFont: ESFontType {
    public var main: UIFont = .systemFont(ofSize: 17)
    
    public var regular: UIFont = .systemFont(ofSize: 17, weight: .bold)
    
    public var bold: UIFont = .systemFont(ofSize: 17, weight: .bold)
    
    public var light: UIFont = .systemFont(ofSize: 17, weight: .light)
    
    public var otherWeights: ESFontWeights = [:]
    
    public var mainSize: CGFloat = 17
    public var language: String = "en"
    
    
    public init (main: UIFont, regular: UIFont, bold: UIFont, light: UIFont, others: ESFontWeights) {
        self.main = main
        self.regular = regular
        self.bold = bold
        self.light = light
        self.otherWeights = others
    }
    
    public init() {}
}

extension ESFont: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.language == rhs.language
    }
}
