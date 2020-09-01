//
//  ESLoggerFileHandler.swift
//  ESCore
//
//  Created by Eslam Hanafy on 9/1/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import Foundation

class ESLoggerFileHandler {
    private let mainFolder: String = "ESLogger/"
    
    private let debugFolder: String = "debug/"
    private let errorFolder: String = "error/"
    private let infoFolder: String = "info/"
    private let warningFolder: String = "warning/"
    private let traceFolder: String = "trace/"
    
    
    
    func write(_ text: String, withLevel level: Level) {
        guard let file = FileManager.createFile(withName: Date.currentDateString + ".txt", atFolder: getFolder(for: level)) else { return }
        guard let data = text.data(using: .utf8) else {
            return print("\(Date.currentDateString(withFormat: "y-MM-dd H:m:ss.SSSS")) ESLoggerFileHandler: the error in writing \(text) is: couldn't convert the text to Data object")
        }
        
        do {
            let handle = try FileHandle(forWritingTo: file)
            handle.seekToEndOfFile()
            handle.write(data)
            handle.closeFile()
        } catch (let error) {
            print("\(Date.currentDateString(withFormat: "y-MM-dd H:m:ss.SSSS")) ESLoggerFileHandler: the error in writing \(text) is: \(error.localizedDescription)")
        }
    }
    
    func getLocalLogs(forLevel level: Level, andDate date: Date) -> String? {
        guard let file = FileManager.createFile(withName: date.currentDateString + ".txt", atFolder: getFolder(for: level)) else { return nil }
        
        do {
            let content = try String(contentsOf: file, encoding: .utf8)
            return content
        } catch (let error) {
            print("\(Date.currentDateString(withFormat: "y-MM-dd H:m:ss.SSSS")) ESLoggerFileHandler: the error in getting the logs for level: \(level) is: \(error.localizedDescription)")
            return nil
        }
    }
}

//MARK: - Private Helpers
private extension ESLoggerFileHandler {
    func getFolder(for level: Level) -> String {
        switch level {
        case .debug:
            return mainFolder + debugFolder
        case .error:
            return mainFolder + errorFolder
        case .info:
            return mainFolder + infoFolder
        case .warning:
            return mainFolder + warningFolder
        case .trace:
            return mainFolder + traceFolder
        }
    }
}

//MARK: - Date Helpers
private extension Date {
    static var currentDateString: String {
        return currentDateString(withFormat: "dd-MM-yyyy")
    }
    
    static func currentDateString(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter.string(from: Date())
    }
    
    var currentDateString: String {
        return currentDateString(withFormat: "dd-MM-yyyy")
    }
    
    func currentDateString(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}
