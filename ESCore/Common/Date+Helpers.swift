//
//  Date+Helpers.swift
//  EslamCore
//
//  Created by Eslam on 3/12/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation
import SwiftDate

public extension Date {
    static var region: Region {
        return Date().date.in(region: Region(calendar: Calendar.current, zone: Zones.current, locale: Locale.current)).region
    }
    
    static var yesterday: Date {
        return Date() - 1.days
    }
    
    static var tomorrow: Date {
        return Date() + 1.days
    }
    
    var currentRegion: DateInRegion {
        return self.date.in(region: Region(calendar: Calendar.current, zone: Zones.current, locale: Locale.current))
    }
    
    var isoRegion: DateInRegion {
        return self.date.in(region: Region.ISO)
    }
    
    func time(format: DateFormatter.Style) -> String {
        return currentRegion.toString(DateToStringStyles.time(format))
    }
    
    func date(format: DateFormatter.Style) -> String {
        return currentRegion.toString(DateToStringStyles.dateTime(format))
    }
}
