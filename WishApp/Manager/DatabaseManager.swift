//
//  DatabaseManager.swift
//  WishApp
//
//  Created by Janosch Hübner on 07.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager : NSObject {
    
    public static let shared: DatabaseManager = DatabaseManager()
    private var realm: Realm!
    
    private override init() {
        super.init()
        
        var config = Realm.Configuration()
        config.fileURL = self.databaseURL
        self.realm = try! Realm(configuration: config)
    }
    
    public var databaseURL: URL? {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.sharedroutine.wishapp")?.appendingPathComponent("Library/Caches/WishApp.realm")
    }
    
    public func write(object: Object) {
        do {
            try self.realm.write {
                self.realm.add(object)
            }
        } catch {
            print("Error writing object to realm: \(error)")
        }
    }
    
    public func delete(object: Object) {
        do {
            try self.realm.write {
                self.realm.delete(object)
            }
        } catch {
            print("Error deleting object from realm: \(error)")
        }
    }
    
    public func write(_ block: () -> ()) {
        do {
            try self.realm.write(block)
        } catch {
            print("Error writing block to realm: \(error)")
        }
    }
    
    public func getObjects<Element: Object>(for type: Element.Type) -> Results<Element> {
        return self.realm.objects(type)
    }
    
    public func getObject<Element: Object, KeyType>(of type: Element.Type, for key: KeyType) -> Element? {
        return self.realm.object(ofType: type, forPrimaryKey: key)
    }
}
