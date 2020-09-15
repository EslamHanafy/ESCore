//
//  DPLanguage.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/4/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation

open class DPLanguage: ESChipItemType {
    open var name: String
    open var code: String
    open var status: ESChipItemStatus = .none
    
    
    public init (name: String, code: String) {
        self.name = name
        self.code = code
    }
    
    public convenience init (locale: Locale) {
        let code = locale.languageCode ?? ""
        let name = Locale.current.localizedString(forLanguageCode: code) ?? ""
        self.init(name: name, code: code)
    }
}

//MARK: - Picker Item Type
extension DPLanguage: ESDataPickerItemType {
    public var title: String {
        return name
    }
    
    public var image: UIImage? {
        return nil
    }
}

//MARK: - Equatable
extension DPLanguage: Equatable {
    public static func == (lhs: DPLanguage, rhs: DPLanguage) -> Bool {
        return lhs.code == rhs.code
    }
}
