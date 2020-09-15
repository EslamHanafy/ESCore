//
//  String+Helpers.swift
//  EslamCore
//
//  Created by Eslam on 1/14/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit
import SwiftDate

public extension String {
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    var withoutDigits: String {
        return (self.components(separatedBy: CharacterSet.decimalDigits)).joined(separator: "")
    }
    
    var digits: Int {
        return Int(self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) ?? 0
    }
    
    var selfLocalized: String {
        return NSLocalizedString(self, bundle: currentBundle, comment: self)
    }
    
    var error: Error {
        return ESError(self)
    }
    
    var image: UIImage? {
        return UIImage(named: self)
    }
    
    var nsstring: NSString {
        return NSString(string: self)
    }
    
    var nsnumberValue: NSNumber {
        return NumberFormatter().number(from: self) ?? 0
    }
    
    var englishNumber: Int {
        return numberToLocale(localeIdentifier: self)?.intValue ?? 0
    }
    
    var intValue: Int {
        return Int(self) ?? 0
    }
    
    var doubleValue: Double {
        return Double(self) ?? 0.0
    }
    
    var floatValue: Float {
        return Float(self) ?? 0
    }
    
    var cgFloatValue: CGFloat {
        return CGFloat(self.floatValue)
    }
    
    var uintValue: UInt {
        return nsnumberValue.uintValue
    }
    
    var decimalValue: NSDecimalNumber {
        return NSDecimalNumber(decimal: nsnumberValue.decimalValue)
    }
    
    var withoutSpaces: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var emailName: String {
        return String(self.split(separator: "@").first ?? "")
    }
    
    
    var validUrlString: String {
        return self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed) ?? ""
    }
    
    var number: Int {
        return numberToLocale(localeIdentifier: "EN")?.intValue ?? 0
    }
    
    var languageCode: String? {
        guard !self.isEmpty else { return nil }
        
        let tagger = NSLinguisticTagger.init(tagSchemes: [.language], options: 0)
        tagger.string = self
        
        return tagger.tag(at: 0, scheme: .language, tokenRange: nil, sentenceRange: nil)?.rawValue
    }
    
    var language: String? {
        guard let code = self.languageCode else { return nil }
        return Locale.current.localizedString(forIdentifier: code)
    }
    
    var hasEnglishText: Bool {
        return self.rangeOfCharacter(from: CharacterSet(charactersIn: "1234567890poiuytrewqasdfghjklmnbvcxz")) != nil
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var colorValue: UIColor {
        return color(withAlpha: 1.0)
    }
    
    
    /// determine if this string refere to BackSpace
    var isBackSpace: Bool {
        let  char = self.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        return isBackSpace == -92
    }
    
    var dictionaryValue: [String: Any] {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return [:]
    }
    
    var uniqueString: String {
        var name = self
        let uniqueText = String.random(ofLength: 5) + "-" + Date().timeIntervalSince1970.stringValue + "-"
        name.insert(contentsOf: uniqueText, at: name.startIndex)
        return name
    }
}

//MARK: - Helper methods
public extension String {
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func copy() {
        UIPasteboard.general.string = self
    }
    
    func dial() {
        if let url = ("tel://" + self).url, UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func mail() {
        if let url = ("mailto:" + self).url, UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func color(withAlpha alpha: CGFloat) -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.black
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    func display(withTitle title: String? = nil, fromController controller: UIViewController? = nil) {
        displayAlert(withTitle: title, andMesseg: self, fromController: controller)
    }
    
    func displayRetryError(withTitle title: String? = nil, fromController controller: UIViewController? = nil, onComplete: @escaping ()->()) {
        displayErrorAlert(withTitle: title, andMessage: self, fromController: controller, onComplete: onComplete)
    }
    
    func displayLocalized(withTitle title: String? = nil, fromController controller: UIViewController? = nil, for bundle: Bundle? = nil) {
        if let bundle = bundle {
            SnackBar.shared.show(message: self.localized(for: bundle))
        } else {
            SnackBar.shared.show(message: self.localized)
        }
    }
    
    
    /// Safely subscript string within a half-open range.
    ///
    ///        "Hello World!"[safe: 6..<11] -> "World"
    ///        "Hello World!"[safe: 21..<110] -> nil
    ///
    /// - Parameter range: Half-open range.
    subscript(safe range: CountableRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex..<upperIndex])
    }
    
    /// Safely subscript string within a closed range.
    ///
    ///        "Hello World!"[safe: 6...11] -> "World!"
    ///        "Hello World!"[safe: 21...110] -> nil
    ///
    /// - Parameter range: Closed range.
    subscript(safe range: ClosedRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex..<upperIndex])
    }
    
    
    func date(format: String) -> Date? {
        return Date(self, format: format)
    }
    
    func remove(_ str: String) -> String {
        return replace(target: str, withString: "")
    }
    
    func localized(for bundle: Bundle) -> String {
        return NSLocalizedString(self, bundle: bundle, comment: self)
    }
    
    func numberToLocale(localeIdentifier: String) -> NSNumber?{
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeIdentifier)
        guard let resultNumber = numberFormatter.number(from: self) else{
            return nil
        }
        return resultNumber
    }
}

//MARK: - Optional
public extension Optional where Wrapped == String {
    var safeValue: String {
        return self ?? ""
    }
}

//MARK: - Custom Operators
infix operator ++
public func ++ (left: String, right: String) -> String {
    return left + " " + right
}
