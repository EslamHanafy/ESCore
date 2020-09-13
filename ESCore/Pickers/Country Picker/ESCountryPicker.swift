//
//  ESCountryPicker.swift
//  ESCore
//
//  Created by Eslam Hanafy on 12/23/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

#if canImport(CountryPickerView)
import Foundation
import CountryPickerView

open class ESCountryPicker: NSObject {
    private let picker = CountryPickerView(frame: UIScreen.main.bounds)
    
    private weak var controller: UIViewController?
    private weak var countryLabel: UILabel?
    
    
    public var selecedCountry: Country {
        return picker.selectedCountry
    }
    
    public var onSelectContry: ((_ country: Country) -> Void)?
    
    public init(_ controller: UIViewController?, _ label: UILabel? = nil, onSelectContry: ((_ country: Country) -> Void)? = nil) {
        super.init()
        
        self.controller = controller
        self.countryLabel = label
        self.onSelectContry = onSelectContry
        
        picker.delegate = self
        picker.dataSource = self
        
        label?.text = selecedCountry.localizedName()
    }
    
    
    public func show() {
        guard let controller = self.controller else { return }
        picker.showCountriesList(from: controller)
    }
    
    public func set(_ code: String) {
        guard !code.isEmpty, let country = picker.getCountryByCode(code) else { return }
        picker.setCountryByCode(code)
        countryLabel?.text = country.localizedName()
    }
    
    public static func country(forCode code: String) -> Country? {
        return CountryPickerView().getCountryByCode(code)
    }
}

//MARK: - Picker Delegate And Data Source
extension ESCountryPicker: CountryPickerViewDelegate, CountryPickerViewDataSource {
    public func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        countryLabel?.text = country.localizedName()
        onSelectContry?(country)
    }
    
    public func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        return ["SA", "EG", "AE", "KW"].map({ countryPickerView.getCountryByCode($0)! })
    }
    
    public func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        return "chooesYourCountry".selfLocalized
    }
    
    public func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
}

#endif
