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

public typealias ESCountrySelection = (_ country: Country) -> Void

open class ESCountryPicker: NSObject {
    private let picker = CountryPickerView(frame: UIScreen.main.bounds)
    
    private weak var countryLabel: UILabel?
    
    
    public var selecedCountry: Country {
        return picker.selectedCountry
    }
    
    public var onSelectCountry: ESCountrySelection?
    
    
    
    public init(label: UILabel? = nil) {
        super.init()
        
        self.countryLabel = label
        
        picker.delegate = self
        picker.dataSource = self
        
        label?.text = selecedCountry.localizedName()
    }
    
    
    public func show(from controller: UIViewController? = currentController, onSelectCountry: ESCountrySelection? = nil) {
        guard let controller = controller else { return }
        picker.showCountriesList(from: controller)
        self.onSelectCountry = onSelectCountry
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
        onSelectCountry?(country)
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
