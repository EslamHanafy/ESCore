//
//  DPCountry.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/5/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

#if canImport(CountryPickerView)
import Foundation
import CountryPickerView

open class DPCountry: ChipItemType {
    open var name: String
    open var code: String
    open var localizedName: String
    open var status: ChipItemStatus = .none
    open var title: String {
        return localizedName
    }
    
    
    
    public init(name: String, code: String, localizedName: String) {
        self.name = name
        self.code = code
        self.localizedName = localizedName
    }
    
    public init(_ country: Country) {
        self.name = country.name
        self.code = country.code
        self.localizedName = country.localizedName() ?? ""
    }
}

//MARK: - Equatable
extension DPCountry: Equatable {
    public static func == (lhs: DPCountry, rhs: DPCountry) -> Bool {
        return lhs.code == rhs.code
    }
}

#endif
