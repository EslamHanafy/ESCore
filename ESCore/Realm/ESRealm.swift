//
//  ESRealm.swift
//  EslamCore
//
//  Created by Eslam on 1/13/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

#if canImport(RealmSwift)
import Foundation
import RealmSwift

/// A helper class to manage all `Realm` operations
public class ESRealm {
    /// The default `Realm` object
    public static let realm: Realm = try! Realm()
    
    public static func objects<Element>(_ type: Element.Type) -> Results<Element> where Element : Object {
        return realm.objects(type)
    }
    
    public static func object<Element, KeyType>(ofType type: Element.Type, forPrimaryKey key: KeyType) -> Element? where Element : Object {
        return realm.object(ofType: type, forPrimaryKey: key)
    }
    
    public static func object<Element, KeyType>(ofType type: Element.Type, forPrimaryKey key: KeyType, `default`: Element) -> Element where Element : Object {
        if let object = realm.object(ofType: type, forPrimaryKey: key) {
            return object
        }
        add(`default`)
        return `default`
    }
    
    public static func add(_ object: Object, update: Bool = true) {
        if realm.isInWriteTransaction {
            realm.add(object, update: update ? .modified : .error)
        }else {
            do {
                try realm.write {
                    realm.add(object, update: update ? .modified : .error)
                }
            } catch let error {
                print("ESRealm failed to add \(object), with error: \(error)")
            }
        }
    }
    
    public static func add<S>(_ objects: S, update: Bool = true, realm: Realm = ESRealm.realm) where S : Sequence, S.Element : Object {
        if realm.isInWriteTransaction {
            realm.add(objects, update: update ? .modified : .error)
        }else {
            do {
                try realm.write {
                    realm.add(objects, update: update ? .modified : .error)
                }
            } catch let error {
                print("ESRealm failed to add \(objects), with error: \(error)")
            }
        }
    }
    
    public static func replace<S> (objects: S, realm: Realm = ESRealm.realm) where S : Sequence, S.Element : Object {
        let removableData = ESRealm.objects(S.Element.self).filter({ !objects.contains($0) })
        add(objects)
        delete(removableData)
    }
    
    public static func replaceWithoutUpdate<S> (objects: S, realm: Realm = ESRealm.realm) where S : Sequence, S.Element : Object {
        clear([S.Element.self])
        add(objects, update: false)
    }
    
    public static func `do`(_ block: (_ realm: Realm)->()) {
        if realm.isInWriteTransaction {
            block(realm)
        }else {
            do {
                try realm.write {
                    block(realm)
                }
            } catch let error {
                print("ESRealm error: \(error)")
            }
        }
    }
    
    public static func `commit`(_ block: ()->()) {
        if realm.isInWriteTransaction {
            block()
        }else {
            do {
                try realm.write {
                    block()
                }
            } catch let error {
                print("ESRealm error: \(error)")
            }
        }
    }
    
    public static func delete<S>(_ objects: S) where S : Sequence, S.Element : Object {
        `do` {
            $0.delete(objects)
        }
    }
    
    public static func delete(_ object: Object) {
        `do` {
            $0.delete(object)
        }
    }
    
    public static func clear<Element>(_ types: [Element.Type]) where Element: Object {
        for type in types {
            delete(realm.objects(type))
        }
    }
    
    public static func migrateNewUpdates(toVersion version: UInt64) {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: version,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < version) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
}

public extension Object {
    func toDictionary() -> NSDictionary {
        let properties = self.objectSchema.properties.map { $0.name }
        let dictionary = self.dictionaryWithValues(forKeys: properties)
        
        let mutabledic = NSMutableDictionary()
        mutabledic.setValuesForKeys(dictionary)
        
        for prop in self.objectSchema.properties as [Property] {
            // find lists
            if let nestedObject = self[prop.name] as? Object {
                mutabledic.setValue(nestedObject.toDictionary(), forKey: prop.name)
            } else if let nestedListObject = self[prop.name] as? ListBase {
                var objects = [AnyObject]()
                for index in 0..<nestedListObject._rlmArray.count  {
                    if let object = nestedListObject._rlmArray[index] as AnyObject as? Object {
                        objects.append(object.toDictionary())
                    }
                }
                mutabledic.setObject(objects, forKey: prop.name as NSCopying)
            }
            
        }
        return mutabledic
    }
    
}

#endif
