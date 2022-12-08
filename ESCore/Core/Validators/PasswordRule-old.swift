//
//  PasswordRule.swift
//  PasswordTextField
//
//  Created by Chris Jimenez on 2/11/16.
//  Copyright © 2016 Chris Jimenez. All rights reserved.
//

//import Foundation
//
//open class PasswordRule : RegexRule {
//    
//    // Other Regexes that you can se
//    
//    // 8 characters. One uppercase. One Lowercase. One number.
//    // static let regex = "^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[a-z]).{8,}$"
//    //
//    // no length. One uppercase. One lowercae. One number.
//    // static let regex = "^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[a-z]).*?$"
//
//    // 8 characeters. One uppercase.
//    //^(?=.*?[A-Z]).{8,}$
//    
//    static let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d@._$!%*#?&]{8,15}$"
//    
//    public convenience init(message : String = "Your password must be at least 8 characters long, max 15 characters length and contain one uppercase letter and one number") {
//        self.init(regex: PasswordRule.regex, errorMessage : message)
//    }
//}
