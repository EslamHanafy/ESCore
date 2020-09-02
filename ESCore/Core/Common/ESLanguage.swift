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
/// L102Language
open class ESLanguage {
    
    public static var closeAlerTitle: String = "ESLanguage_CloseAlerTitle".selfLocalized
    public static var closeAlertBody: String = "ESLanguage_ColseAlertBody".selfLocalized
    public static var closeAlertCloseButtonTitle: String = "ESLanguage_CloseAlertCloseButtonTitle".selfLocalized
    public static var closeAlertLaterButtonTitle: String = "ESLanguage_CloseAlertLaterButtonTitle".selfLocalized
    
    public static var changeLanguageTitle: String = "ESLanguage_ChangeLanguageTitle".selfLocalized
    public static var changeLanguageBody: String = "ESLanguage_ChangeLanguageBody".selfLocalized
    public static var changeLanguageConfirmButtonTitle: String = "ESLanguage_ChangeLanguageConfirmButtonTitle".selfLocalized
    public static var changeLanguageDeclineButtonTitle: String = "ESLanguage_ChangeLanguageDeclineButtonTitle".selfLocalized
    
    
    /// get current Apple language
    public class func currentAppleLanguage() -> String{
        return isRTL ? "ar" : "en"
    }
    
    public class func currentAppleLanguageFull() -> String{
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
    
    /// set @lang to be the first in Applelanguages list
    public class func setAppleLAnguageTo(lang: String) {
        let userdef = UserDefaults.standard
        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
    }
    
    public class func changeAppLanguage(from controller: UIViewController? = currentController) {
        let alert = UIAlertController(title: changeLanguageTitle,
                                      message: changeLanguageBody,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: changeLanguageConfirmButtonTitle,
                                      style: .destructive, handler: { (_) in
                                        
                                        ESLanguage.setAppleLAnguageTo(lang: isRTL ? "en" : "ar")
                                        displayCloseAlert(for: controller)
        }))
        
        alert.addAction(UIAlertAction(title: changeLanguageDeclineButtonTitle, style: .cancel, handler: nil))
        controller?.present(alert, animated: true, completion: nil)
    }
    
    private class func displayCloseAlert(for controller: UIViewController?) {
        let alert = UIAlertController(title: closeAlerTitle, message: closeAlertBody, preferredStyle: .alert)
        
        alert.addAction(.init(title: closeAlertCloseButtonTitle, style: .destructive, handler: { (_) in
            exit(0)
        }))
        
        alert.addAction(.init(title: closeAlertLaterButtonTitle, style: .cancel, handler: nil))
        controller?.present(alert, animated: true, completion: nil)
    }
}
