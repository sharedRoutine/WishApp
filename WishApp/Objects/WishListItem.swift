//
//  WishListItem.swift
//  WishApp
//
//  Created by Janosch Hübner on 07.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation
import RealmSwift

class WishListItem: Object {
    @objc dynamic var name: String!
    @objc dynamic var developer: String!
    @objc dynamic var storeIdentifier: String!
    @objc dynamic var bundleIdentifier: String!
    @objc dynamic var appStoreURL: String!
    @objc dynamic var imageName: String? = nil
    @objc dynamic var price: Float = 0.0
    @objc dynamic var dateAdded: Date = Date()
    @objc dynamic var dateCompleted: Date? = nil
    
    @objc dynamic var fulfilled: Bool = false
    
    required convenience init(with app: WishListable) {
        self.init()
        
        self.bundleIdentifier = app.bundleIdentifier // primary key cannot be changed afterwards
        self.update(with: app)
    }
    
    public func update(with app: WishListable) {
        self.appStoreURL = app.appStoreURL
        self.price = app.price
        self.name = app.name
        self.developer = app.developer
        self.storeIdentifier = app.storeIdentifier
    }
    
    override static func primaryKey() -> String? {
        return "bundleIdentifier"
    }
}
