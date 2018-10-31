//
//  iTunesApp.swift
//  WishApp
//
//  Created by Janosch Hübner on 31.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation

class iTunesApp : Decodable {
    
    let name: String
    let developer: String
    let appStoreURL: String
    let storeIdentifier: String
    let bundleIdentifier: String
    
    enum CodingKeys: String, CodingKey {
        case bundleIdentifier = "bundleId"
        case developer = "artistName"
    }
    
    enum NameCodingKeys: String, CodingKey {
        case name
        case trackName
    }
    
    enum URLCodingKeys: String, CodingKey {
        case trackViewUrl
        case url
    }
    
    enum StoreIDCodingKeys: String, CodingKey {
        case id
        case trackId
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nameContainer = try decoder.container(keyedBy: NameCodingKeys.self)
        let urlContainer = try decoder.container(keyedBy: URLCodingKeys.self)
        let storeIDContainer = try decoder.container(keyedBy: StoreIDCodingKeys.self)
        
        self.developer = try container.decode(String.self, forKey: .developer)
        self.bundleIdentifier = try container.decode(String.self, forKey: .bundleIdentifier)
        
        if nameContainer.contains(.name) {
            self.name = try nameContainer.decode(String.self, forKey: .name)
        } else if nameContainer.contains(.trackName) {
            self.name = try nameContainer.decode(String.self, forKey: .trackName)
        } else {
            fatalError("Invalid JSON Data")
        }
        
        if urlContainer.contains(.trackViewUrl) {
            self.appStoreURL = try urlContainer.decode(String.self, forKey: .trackViewUrl)
        } else if urlContainer.contains(.url) {
            self.appStoreURL = try urlContainer.decode(String.self, forKey: .url)
        } else {
            fatalError("Invalid JSON Data")
        }
        
        if storeIDContainer.contains(.id) {
            self.storeIdentifier = try storeIDContainer.decode(String.self, forKey: .id)
        } else if storeIDContainer.contains(.trackId) {
            self.storeIdentifier = try storeIDContainer.decode(String.self, forKey: .trackId)
        } else {
            fatalError("Invalid JSON Data")
        }
    }
}
