//
//  SurahPicker.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/31/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit
import SwiftyJSON

open class SurahPicker {
    private var picker: DataPickerViewController!
    
    public static let shared: SurahPicker = {
        let style = DataPickerStyle()
        return SurahPicker(style: style)
    }()
    
    public var onSelectSurah: ((_ surah: Surah) -> Void)?
    
    public static let allSurah: [Surah] = quranData["sura"].arrayValue.map({ Surah.map($0) }).sorted(by: \.id, ascending: true)
    
    public static let quranData: JSON = {
        if let path = currentBundle.path(forResource: "Quran-Metadata", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let json = try JSON(data: data)
                return json
            } catch (let error) {
                Log.error("Eslam the error in parsing quran data is: \(error.localizedDescription)")
            }
        }
        Log.debug("Eslam we couldn't get the quran data")
        return JSON()
    }()
    
    
    
    public init(style: DataPickerStyle) {
//        var grouped = Dictionary<String, [Surah]>(grouping: SurahPicker.allSurah) { (surah) -> String in
//            return String(surah.localizedName.capitalized[surah.localizedName.startIndex])
//        }
//
//        grouped.forEach{ key, value in
//            grouped[key] = value.sorted(by: { (lhs, rhs) -> Bool in
//                return lhs.localizedName < rhs.localizedName
//            })
//        }
        
        let grouped: [String: [Surah]] = ["holyQuran".selfLocalized: SurahPicker.allSurah]
        
        style.showSectionIndexTitles = false
        
        let data = DPDataSource(screenTitle: "holyQuran".selfLocalized, items: grouped)
        self.picker = DataPickerViewController(with: data, and: style)
        self.picker.selectedItem(type: Surah.self) { [weak self] (item) in
            guard let self = self else { return }
            self.onSelectSurah?(item)
        }
    }
    
    
    public func show(from controller: UIViewController? = currentController, _ onSelectHandler: ((_ surah: Surah) -> Void)? = nil) {
        picker.show(from: controller)
        if let handler = onSelectHandler {
            self.onSelectSurah = handler
        }
    }
    
    
    static func surah(withId id: Int) -> Surah? {
        return allSurah.first(where: { $0.id == id })
    }
}
