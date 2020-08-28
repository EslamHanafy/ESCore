//
//  FileManager+Helpers.swift
//  EslamCore
//
//  Created by Eslam on 9/4/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import Foundation

public extension FileManager {
    static var documentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory,
                                in: .userDomainMask)[0]
    }
    
    @discardableResult
    static func createFolder(withName name: String) -> URL? {
        let fileManager = FileManager.default
        
        // Construct a URL with desired folder name
        let folderURL = documentDirectory.appendingPathComponent(name)
        // If folder URL does not exist, create it
        if !fileManager.fileExists(atPath: folderURL.path) {
            do {
                // Attempt to create folder
                try fileManager.createDirectory(atPath: folderURL.path,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch {
                // Creation failed. Print error & return nil
                Log.error(error.localizedDescription)
                return nil
            }
        }
        // Folder either exists, or was created. Return URL
        return folderURL
    }
    
    @discardableResult
    static func clearFiles(atFolder folder: String) -> Bool {
        let fileManager = FileManager.default
        let folderURL = documentDirectory.appendingPathComponent(folder)
        if fileManager.fileExists(atPath: folderURL.path) {
            do {
                try fileManager.removeItem(at: folderURL)
                createFolder(withName: folder)
            } catch let error {
                Log.error("The error in clearing \(folder) is: ", error.localizedDescription)
                return false
            }
        }
        return true
    }
    
    @discardableResult
    static func copy(fileAt path: URL?, toFolder folder: String) -> URL? {
        guard let path = path else { return nil }
        
        if let newPath = createFolder(withName: folder)?.appendingPathComponent(path.lastPathComponent) {
            do {
                if FileManager.default.fileExists(atPath: newPath.path) {
                    try FileManager.default.removeItem(at: newPath)
                }
                
                try FileManager.default.copyItem(at: path, to: newPath)
                return newPath
            } catch let error {
                Log.error("The error in copying \(path) is: ", error.localizedDescription)
            }
        }
        return nil
    }
    
    @discardableResult
    static func store(fileData data: Data, withName name: String, atFolder folder: String, useUniqueName: Bool = false) -> URL? {
        let fileName = useUniqueName ? name.uniqueString : name
        let url = createFolder(withName: folder)?.appendingPathComponent(fileName)
        if let path = url {
            do {
                try data.write(to: path)
                return path
            } catch let error {
                Log.error("The error in storing \(name) at \(folder) is: ", error.localizedDescription)
            }
        }
        
        return nil
    }
    
    @discardableResult
    static func remove(fileAt url: URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: url)
            return true
        } catch let error {
            Log.error("The error in removing \(url.absoluteString) is: ", error.localizedDescription)
            return false
        }
    }
}
