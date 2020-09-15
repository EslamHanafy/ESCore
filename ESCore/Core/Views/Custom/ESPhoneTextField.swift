//
//  ESPhoneTextField.swift
//  ESCore
//
//  Created by Eslam on 12/19/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import FlagPhoneNumber

open class ESPhoneTextField: FPNTextField {
    @IBOutlet public var controller: UIViewController?
    
    @IBInspectable open var customFont: String = "main" {
        didSet {
            self.font = Fonts.font(for: customFont)
        }
    }
    
    
    public var isValidNumber: Bool = false
    
    public var number: String { return self.getFormattedPhoneNumber(format: .E164) ?? "" }
    
    public var countryCode: String? {
        return self.selectedCountry?.code.rawValue
    }
    
    public var dialCode: String? {
        return self.selectedCountry?.phoneCode
    }
    
    private let listController = FPNCountryListViewController(style: .grouped)
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        initPhoneTextField()
    }
}

//MARK: - text field Delegate
extension ESPhoneTextField : FPNTextFieldDelegate {
    public func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)

        listController.title = "chooseCountryCode".selfLocalized
        listController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissCountriesList))

        controller?.present(navigationViewController, animated: true, completion: nil)
    }
    
    public func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        
    }
    
    public func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        isValidNumber = isValid
    }
    
    fileprivate func initPhoneTextField() {
        self.delegate = self
        self.keyboardType = .phonePad
        self.displayMode = .list
        self.keyboardType = .asciiCapableNumberPad
        self.semanticContentAttribute = .forceLeftToRight
        self.textAlignment = .left
        listController.setup(repository: self.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.setFlag(countryCode: country.code)
        }
    }
    
    @objc func dismissCountriesList() {
        listController.dismiss(animated: true, completion: nil)
    }
}
