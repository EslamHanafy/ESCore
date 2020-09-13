//
//  ESSurah.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/31/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation
import SwiftyJSON

open class ESSurah {
    open var id: Int = 0
    open var ayahCount: Int = 0
    open var nameAr: String = ""
    open var nameEn: String = ""
    
    open var localizedName: String {
        return isRTL ? nameAr : nameEn
    }
    
    open var ayahArray: [Int] {
        return Array<Int>(1...ayahCount)
    }
    
    
    public init() {}
}

//MARK: - JSON
extension ESSurah: Mapable {
    public static func map(_ json: JSON) -> ESSurah {
        let surah = ESSurah()
        surah.id = json["index"].intValue
        surah.ayahCount = json["ayas"].intValue
        surah.nameEn = json["tname"].stringValue
        surah.nameAr = json["name"].stringValue
        return surah
    }
}

//MARK: - Picker Item Type
extension ESSurah: ESDataPickerItemType {
    public var title: String {
        return localizedName
    }
}
