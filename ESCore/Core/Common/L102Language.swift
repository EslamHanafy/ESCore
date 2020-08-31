//
//  L102Language.swift
//  ESCore
//
//  Created by Eslam Hanafy on 12/24/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

// constants
let APPLE_LANGUAGE_KEY = "AppleLanguages"
/// L102Language
public class L102Language {
    private static let enMessage: String = "The language will be changed when you reopen the app again. To execute the change, please close the application permanently and reopen it."
    
    private static let arMessage: String = "سيتم تغيير اللغة عند إعادة فتح التطبيق مرة أخرى، لتنفيذ التغيير يرجى غلق التطبيق نهائيا ثم إعادة فتحه مجددا."
    
    private static let enTitle: String = "Change language"
    private static let arTitle: String = "تغير اللغة"
    
    private static let enClose: String = "Close";
    private static let arClose: String = "إغلاق";
    
    private static let enLater: String = "Later";
    private static let arLater: String = "في وقت لاحق";
    
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
        let alert = UIAlertController(title: "changeLanguageTitle".localized,
                                      message: "changeLanguageBody".localized,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "yes".localized,
                                      style: .destructive, handler: { (_) in
                                        
                                        L102Language.setAppleLAnguageTo(lang: isRTL ? "en" : "ar")
                                        displayCloseAlert(for: controller)
        }))
        
        alert.addAction(UIAlertAction(title: "no".localized, style: .cancel, handler: nil))
        controller?.present(alert, animated: true, completion: nil)
    }
    
    private class func displayCloseAlert(for controller: UIViewController?) {
        let message = isRTL ? enMessage : arMessage
        let close = isRTL ? enClose : arClose
        let later = isRTL ? enLater : arLater
        let title = isRTL ? enTitle : arTitle
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(.init(title: close, style: .destructive, handler: { (_) in
            exit(0)
        }))
        
        alert.addAction(.init(title: later, style: .cancel, handler: nil))
        controller?.present(alert, animated: true, completion: nil)
    }
}
