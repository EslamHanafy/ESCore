//
//  ESSurahPicker.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/31/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit
import SwiftyJSON

open class ESSurahPicker {
    private var picker: ESDataPickerViewController!
    
    
    public var onSelectSurah: ((_ surah: ESSurah) -> Void)?
    
    public static let allSurah: [ESSurah] = quranData["sura"].arrayValue.map({ ESSurah.map($0) }).sorted(by: \.id, ascending: true)
    
    public static let quranData: JSON = {
        if let path = currentBundle.path(forResource: "Quran-Metadata", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let json = try JSON(data: data)
                return json
            } catch (let error) {
                Log.error("The error in parsing quran data is: \(error.localizedDescription)")
            }
        }
        Log.debug("We couldn't get the quran data")
        return JSON()
    }()
    
    
    
    public init(style: ESDataPickerStyle = ESDataPickerStyle()) {
        var grouped: Dictionary<String, [ESSurah]>
        if style.sortedAlphabetically {
            grouped = Dictionary<String, [ESSurah]>(grouping: ESSurahPicker.allSurah) { (surah) -> String in
                return String(surah.localizedName.capitalized[surah.localizedName.startIndex])
            }
            
            grouped.forEach{ key, value in
                grouped[key] = value.sorted(by: { (lhs, rhs) -> Bool in
                    return lhs.localizedName < rhs.localizedName
                })
            }
        } else {
            grouped = ["holyQuran".selfLocalized: ESSurahPicker.allSurah]
            style.showSectionIndexTitles = false
        }
        
        
        let data = DPDataSource(screenTitle: "holyQuran".selfLocalized, items: grouped)
        self.picker = ESDataPickerViewController(with: data, and: style)
        self.picker.selectedItem(type: ESSurah.self) { [weak self] (item) in
            guard let self = self else { return }
            self.onSelectSurah?(item)
        }
    }
    
    
    public func show(from controller: UIViewController? = currentController, _ onSelectHandler: ((_ surah: ESSurah) -> Void)? = nil) {
        picker.show(from: controller)
        if let handler = onSelectHandler {
            self.onSelectSurah = handler
        }
    }
    
    
    static func surah(withId id: Int) -> ESSurah? {
        return allSurah.first(where: { $0.id == id })
    }
}
