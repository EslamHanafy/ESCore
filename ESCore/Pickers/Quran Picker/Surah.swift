//
//  Surah.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/31/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation
import SwiftyJSON

open class Surah {
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
extension Surah: Mapable {
    public static func map(_ json: JSON) -> Surah {
        let surah = Surah()
        surah.id = json["index"].intValue
        surah.ayahCount = json["ayas"].intValue
        surah.nameEn = json["tname"].stringValue
        surah.nameAr = json["name"].stringValue
        return surah
    }
}

//MARK: - Picker Item Type
extension Surah: DataPickerItemType {
    public var title: String {
        return localizedName
    }
}
