//
//  UIDevice+Helpers.swift
//  ESCore
//
//  Created by Eslam Hanafy on 12/11/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit
import AVFoundation

public extension UIDevice {
    var modelIdentifier: String {
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    var hasHapticFeedback: Bool {

        // assuming that iPads and iPods don't have a Taptic Engine
        if !modelIdentifier.contains("iPhone") {
            return false
        }

        // e.g. will equal to "9,5" for "iPhone9,5"
        let subString = String(modelIdentifier[modelIdentifier.index(modelIdentifier.startIndex, offsetBy: 6)..<modelIdentifier.endIndex])

        // will return true if the generationNumber is equal to or greater than 9
        if let generationNumberString = subString.components(separatedBy: ",").first,
            let generationNumber = Int(generationNumberString),
            generationNumber >= 9 {
            return true
        }

        return false
    }
    
    
    enum Vibration {
        case error
        case success
        case warning
        case light
        case medium
        case heavy
        case selection
        case oldSchool

        func vibrate() {
            if UIDevice.current.hasHapticFeedback {
                switch self {
                case .error:
                  let generator = UINotificationFeedbackGenerator()
                  generator.notificationOccurred(.error)

                case .success:
                  let generator = UINotificationFeedbackGenerator()
                  generator.notificationOccurred(.success)

                case .warning:
                  let generator = UINotificationFeedbackGenerator()
                  generator.notificationOccurred(.warning)

                case .light:
                  let generator = UIImpactFeedbackGenerator(style: .light)
                  generator.impactOccurred()

                case .medium:
                  let generator = UIImpactFeedbackGenerator(style: .medium)
                  generator.impactOccurred()

                case .heavy:
                  let generator = UIImpactFeedbackGenerator(style: .heavy)
                  generator.impactOccurred()

                case .selection:
                  let generator = UISelectionFeedbackGenerator()
                  generator.selectionChanged()

                case .oldSchool:
                  AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
            } else {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
}
