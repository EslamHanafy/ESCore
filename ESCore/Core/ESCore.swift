//
//  ESCore.swift
//  ESCore
//
//  Created by Eslam Hanafy on 8/28/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation


//MARK: - Fonts
public struct Fonts {
    public static var main: UIFont = .systemFont(ofSize: 17)
    public static var bold: UIFont = .systemFont(ofSize: 17, weight: .bold)
    public static var light: UIFont = .systemFont(ofSize: 17, weight: .light)
    
    public static func main(ofSize size: CGFloat) -> UIFont {
        return main.withSize(size)
    }
    
    public static func bold(ofSize size: CGFloat) -> UIFont {
        return bold.withSize(size)
    }
    
    public static func light(ofSize size: CGFloat) -> UIFont {
        return light.withSize(size)
    }
}

