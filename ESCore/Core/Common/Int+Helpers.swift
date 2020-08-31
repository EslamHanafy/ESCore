//
//  Int+Helpers.swift
//  EslamCore
//
//  Created by Eslam on 1/14/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

public extension Int {
    var doubleValue: Double {
        return Double(self)
    }
    
    var stringValue: String {
        return String(self)
    }
    
    var cgFloatValue: CGFloat {
        return CGFloat(self)
    }
    
    var timeString: String {
        let components = secondsToHoursMinutesSeconds()
        let hours = components.hours < 10 ? "0" + components.hours.stringValue : components.hours.stringValue
        let minutes = components.minutes < 10 ? "0" + components.minutes.stringValue : components.minutes.stringValue
        let seconds = components.seconds < 10 ? "0" + components.seconds.stringValue : components.seconds.stringValue
        return "\(hours):\(minutes):\(seconds)"
    }
    
    func plus(_ value: Int) -> Int {
        return self + value
    }
    
    func secondsToHoursMinutesSeconds () -> (hours: Int, minutes: Int, seconds: Int) {
      return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
    }
}

//MARK: - Optional
public extension Optional where Wrapped == Int {
    var safeValue: Int {
        return self ?? 0
    }
}
