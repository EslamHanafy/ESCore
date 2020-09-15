//
//  ESFontType.swift
//  ESCore
//
//  Created by Eslam Hanafy on 9/15/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit

public protocol ESFontType {
    var main: UIFont { get set }
    var regular: UIFont { get set }
    var bold: UIFont { get set }
    var light: UIFont { get set }
    
    var otherWeights: [String: UIFont] { get set }
    
    var mainSize: CGFloat { get set }
    var language: String { get set }
}
