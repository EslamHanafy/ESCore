//
//  ESLogger.swift
//  ESCore
//
//  Created by Eslam Hanafy on 9/1/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation

open class ESLogger: Logger {
    public static let shared: ESLogger = ESLogger(formatter: .detailed, theme: nil)
    
    /// Determine that the logger should  store the messages in a local file or not, default is `false`
    open var writeToLocalFile: Bool = false
    
    /// Determine the min level of messages to write them in the local file, this requires `writeToLocalFile` to set to `true` to work, the default value is `.warning`
    open var minWriteLevel: Level = .warning
    
    
    private lazy var fileHandler = ESLoggerFileHandler()
    
    
    
    
    
    open func trace(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        let result = super.trace(items, separator: separator, terminator: terminator)
        
        if writeToLocalFile && minWriteLevel <= .trace {
            fileHandler.write(result, withLevel: .trace)
        }
    }
    
    
    open func debug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        let result = super.debug(items, separator: separator, terminator: terminator)
        
        if writeToLocalFile && minWriteLevel <= .debug {
            fileHandler.write(result, withLevel: .debug)
        }
    }
    
    
    open func info(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        let result = super.info(items, separator: separator, terminator: terminator)
        
        if writeToLocalFile && minWriteLevel <= .info {
            fileHandler.write(result, withLevel: .info)
        }
    }
    
    
    open func warning(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        let result = super.warning(items, separator: separator, terminator: terminator)
        
        if writeToLocalFile && minWriteLevel <= .warning {
            fileHandler.write(result, withLevel: .warning)
        }
    }
    
    
    open func error(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        let result = super.error(items, separator: separator, terminator: terminator)
        
        if writeToLocalFile && minWriteLevel <= .error {
            fileHandler.write(result, withLevel: .error)
        }
    }
    
    
    func getLocalLogs(forLevel level: Level, andDate date: Date) -> String? {
        return fileHandler.getLocalLogs(forLevel: level, andDate: date)
    }
}
