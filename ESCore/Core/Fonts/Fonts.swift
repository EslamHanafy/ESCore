//
//  Fonts.swift
//  ESCore
//
//  Created by Eslam Hanafy on 8/28/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit

public typealias ESFonts = ESCore.Fonts

typealias Fonts = ESCore.Fonts

public extension ESCore {
    struct Fonts {
        public static var availableFonts: [String: ESFontType] = ["en": ESFont()]
        
        public static var main: UIFont {
            return (availableFonts[safe: language] ?? ESFont()).main
        }
        
        public static var regular: UIFont {
            return (availableFonts[safe: language] ?? ESFont()).regular
        }
        
        public static var bold: UIFont {
            return (availableFonts[safe: language] ?? ESFont()).bold
        }
        
        public static var light: UIFont {
            return (availableFonts[safe: language] ?? ESFont()).light
        }
        
        public static var mainSize: CGFloat {
            return (availableFonts[safe: language] ?? ESFont()).mainSize
        }
        
        
        public static func main(ofSize size: CGFloat) -> UIFont {
            return main.withSize(size)
        }
        
        public static func regular(ofSize size: CGFloat) -> UIFont {
            return regular.withSize(size)
        }
        
        public static func bold(ofSize size: CGFloat) -> UIFont {
            return bold.withSize(size)
        }
        
        public static func light(ofSize size: CGFloat) -> UIFont {
            return light.withSize(size)
        }
        
        public static func otherWeight(withName name: String, andSize size: CGFloat? = nil) -> UIFont? {
            let font: ESFontType = (availableFonts[safe: language] ?? ESFont())
            return font.otherWeights[safe: name]?.withSize(size ?? mainSize)
        }
        
        
        public static func font(for string: String) -> UIFont {
            let (name, param) = extractNameAndParams(from: string)
            
            switch name {
            case "main":
                return main
                
            case "regular":
                return regular(ofSize: param[safe: 0]?.cgFloatValue ?? mainSize)
                
            case "bold":
                return bold(ofSize: param[safe: 0]?.cgFloatValue ?? mainSize)
                
            case "light":
                return light(ofSize: param[safe: 0]?.cgFloatValue ?? mainSize)
                
            default:
                if let font = otherWeight(withName: name, andSize: param[safe: 0]?.cgFloatValue ?? mainSize) {
                    return font
                }
                return main
            }
        }
        
        public static func accept(_ font: ESFontType, forLanguage language: String) {
            availableFonts[language] = font
        }
        
        
        private static func extractNameAndParams(from string: String) -> (name: String, params: [String]) {
            let tokens = string.components(separatedBy: CharacterSet(charactersIn: "()")).filter { !$0.isEmpty }
            let name = tokens.first ?? ""
            let paramsString = tokens.count >= 2 ? tokens[1] : ""
            let params = paramsString.components(separatedBy: ",").filter { !$0.isEmpty }.map { $0.trimmingCharacters(in: .whitespaces) }
            
            return (name: name, params: params)
        }
    }
}
