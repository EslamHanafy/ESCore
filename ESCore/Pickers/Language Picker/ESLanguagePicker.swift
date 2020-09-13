//
//  ESLanguagePicker.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/4/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit

open class ESLanguagePicker {
    private var picker: ESDataPickerViewController!
    
    public var onSelectLanguage: ((_ language: DPLanguage) -> Void)?
    
    public static let languages: [DPLanguage] = Locale.availableIdentifiers
        .map { Locale(identifier:$0) }
        .filter({ $0.regionCode != nil && $0.languageCode != nil && $0.languageCode != "ccp" })
        .withoutDuplicates(transform: { $0.languageCode }).map({ DPLanguage(locale: $0) })
    
    
    
    public init(style: ESDataPickerStyle) {
        var grouped = Dictionary<String, [DPLanguage]>(grouping: ESLanguagePicker.languages) { (lang) -> String in
            return String(lang.name.capitalized[lang.name.startIndex])
        }

        grouped.forEach{ key, value in
            grouped[key] = value.sorted(by: { (lhs, rhs) -> Bool in
                return lhs.name < rhs.name
            })
        }
        
        style.showSectionIndexTitles = true
        
        let data = DPDataSource(screenTitle: "languages".selfLocalized, items: grouped)
        self.picker = ESDataPickerViewController(with: data, and: style)
        self.picker.onSelectItem = { [weak self] item in
            guard let self = self else { return }
            self.onSelectLanguage?(item as! DPLanguage)
        }
    }
    
    public func show(from controller: UIViewController? = currentController) {
        picker.show(from: controller)
    }
    
//    static func languages() -> [String] {
//        var languages = [String]()
//        let currentLocale = NSLocale.current as NSLocale
//        for languageCode in NSLocale.availableLocaleIdentifiers {
//            if let name = currentLocale.displayName(forKey: NSLocale.Key.languageCode, value: languageCode), !languages.contains(name) {
//                languages.append(name)
//            }
//        }
//        return languages.sorted()
//    }
    
    public static func language(withName name: String) -> DPLanguage? {
        return languages.first(where: { $0.name == name })
    }
    
    public static func language(withCode code: String) -> DPLanguage? {
        return languages.first(where: { $0.code == code })
    }
    
    public static func map(languageNames: [String]) -> [DPLanguage] {
        languageNames.map({ language(withName: $0) }).unwrap()
    }
    
    public static func map(languageCodes: [String]) -> [DPLanguage] {
        return languageCodes.map({ language(withCode: $0) }).unwrap()
    }
}
