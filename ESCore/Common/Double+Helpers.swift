//
//  Double+Helpers.swift
//  EslamCore
//
//  Created by Eslam on 1/14/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation

public extension Double {
    var stringValue: String {
        return String(self)
    }
    
    var currency: String {
        return stringValue + " " + "currency".selfLocalized
    }
    
    var dateValue: Date {
        return Date(timeIntervalSince1970: self)
    }
    
    var intValue: Int {
        guard (self <= Double(Int.max).nextDown) && (self >= Double(Int.min).nextUp) else {
            return 0
        }

        return Int(self)
    }
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
      let formatter = DateComponentsFormatter()
      formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
      formatter.unitsStyle = style
      guard let formattedString = formatter.string(from: self) else { return "" }
      return formattedString
    }
    
    
}

//MARK: - Optional
public extension Optional where Wrapped == Double {
    var safeValue: Double {
        return self ?? 0
    }
}

public extension FloatingPoint {
    var whole: Self { modf(self).0 }
    var fraction: Self { modf(self).1 }
}
