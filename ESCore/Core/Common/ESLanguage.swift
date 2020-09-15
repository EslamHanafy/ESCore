//
//  ESLanguage.swift
//  ESCore
//
//  Created by Eslam Hanafy on 12/24/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

// constants
let APPLE_LANGUAGE_KEY = "AppleLanguages"


/// A helpers class to manage the app languages
open class ESLanguage {
    
    /// The settings object that controls all displayed texts in all alerts in this class
    public static var settings: Settings = Settings()
    
    private static let RTLLanguages = ["ar", "fa", "he", "ckb-IQ","ckb-IR", "ur", "ckb"]
    
    private static var preferredLanguage: [String] {
        let userDefaults = UserDefaults.standard
        let langArray = userDefaults.object(forKey: APPLE_LANGUAGE_KEY)
        return langArray as? [String] ?? []
    }
    
    
    /// get current app language
    /// - Returns: The current app language e.g `ar` for Arabic or `en` for english
    public class func currentAppleLanguage() -> String{
        let current = preferredLanguage.first!
        if let hyphenIndex = current.firstIndex(of: "-") {
            return String(current[..<hyphenIndex])
        } else {
            return current
        }
    }
    
    /// Get current app language in full format
    /// - Returns: the current app language in full format
    public class func currentAppleLanguageFull() -> String{
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
    
    /**
     Check if the current language is a right to left language
     
     @return true if its a right to left language
     */
    public static func isRTLLanguage() -> Bool {
        return !RTLLanguages.filter{$0 == currentLocaleIdentifier() || $0 == currentAppleLanguage()}.isEmpty
    }
    
    /**
     Get the current language with locae e.g. ar-KW
     @return language identifier string
     */
    public class func currentLocaleIdentifier() -> String {
        let current = preferredLanguage.first!
        return current
    }
    
    
    /**
     Check if the current language is a right to left language
     
     @param language to be tested
     @return true if its a right to left language
     */
    public static func isRTLLanguage(language: String) -> Bool {
        return !RTLLanguages.filter{language == $0}.isEmpty
    }
    
    
    /// Change the app language to the given key
    /// - Parameter lang: The language key, like `ar` for Arabic, and `en` for English
    public class func setAppleLAnguageTo(lang: String) {
        let userdef = UserDefaults.standard
        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
    }
    
    
    /// Display an alert to the user to toggle the app language
    /// - Parameter controller: The current view controller
    public class func changeAppLanguage(from controller: UIViewController? = currentController) {
        let alert = UIAlertController(title: settings.changeLanguageTitle,
                                      message: settings.changeLanguageBody,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: settings.changeLanguageConfirmButtonTitle,
                                      style: .destructive, handler: { (_) in
                                        
                                        setAppleLAnguageTo(lang: isRTL ? "en" : "ar")
                                        displayCloseAlert(for: controller)
        }))
        
        alert.addAction(UIAlertAction(title: settings.changeLanguageDeclineButtonTitle, style: .cancel, handler: nil))
        controller?.present(alert, animated: true, completion: nil)
    }
    
    private class func displayCloseAlert(for controller: UIViewController?) {
        let alert = UIAlertController(title: settings.closeAlerTitle, message: settings.closeAlertBody, preferredStyle: .alert)
        
        alert.addAction(.init(title: settings.closeAlertCloseButtonTitle, style: .destructive, handler: { (_) in
            exit(0)
        }))
        
        alert.addAction(.init(title: settings.closeAlertLaterButtonTitle, style: .cancel, handler: nil))
        controller?.present(alert, animated: true, completion: nil)
    }
}

//MARK: - Settings
public extension ESLanguage {
    struct Settings {
        /// The close alert's title, the close alert will be displayed after changing the language using `changeAppLanguage(from:)` method
        public var closeAlerTitle: String = "ESLanguage_CloseAlerTitle".selfLocalized
        
        /// The close alert's body, the close alert will be displayed after changing the language using `changeAppLanguage(from:)` method
        public var closeAlertBody: String = "ESLanguage_ColseAlertBody".selfLocalized
        
        /// The close alert close button's title, the close alert will be displayed after changing the language using `changeAppLanguage(from:)` method
        public var closeAlertCloseButtonTitle: String = "ESLanguage_CloseAlertCloseButtonTitle".selfLocalized
        
        /// The close alert later button's title, the close alert will be displayed after changing the language using `changeAppLanguage(from:)` method
        public var closeAlertLaterButtonTitle: String = "ESLanguage_CloseAlertLaterButtonTitle".selfLocalized
        
        /// The change language alert's title, the change language alert will be displayed using the `changeAppLanguage(from:)` method
        public var changeLanguageTitle: String = "ESLanguage_ChangeLanguageTitle".selfLocalized
        
        /// The change language alert's body, the change language alert will be displayed using the `changeAppLanguage(from:)` method
        public var changeLanguageBody: String = "ESLanguage_ChangeLanguageBody".selfLocalized
        
        /// The change language alert confirm button's title, the change language alert will be displayed using the `changeAppLanguage(from:)` method
        public var changeLanguageConfirmButtonTitle: String = "ESLanguage_ChangeLanguageConfirmButtonTitle".selfLocalized
        
        /// The change language alert decline button's title, the change language alert will be displayed using the `changeAppLanguage(from:)` method
        public var changeLanguageDeclineButtonTitle: String = "ESLanguage_ChangeLanguageDeclineButtonTitle".selfLocalized
    }
}
