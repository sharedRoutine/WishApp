//
//  App.swift
//  WishApp
//
//  Created by Janosch Hübner on 18.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation

struct App : Decodable, WishListable {
    
    let appStoreURL: String
    let developer: String
    let bundleIdentifier: String
    let priceString: String?
    let name: String
    let price: Float
    let iconFile: String
    let storeIdentifier: String
    
    public var isFree: Bool {
        return self.price <= 0.0
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case price
        case priceString = "formattedPrice"
        case iconFile = "artworkUrl100"
        case developer = "artistName"
        case bundleIdentifier = "bundleId"
        case appStoreURL = "trackViewUrl"
        case storeIdentifier = "trackId"
    }
    
    init(with decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        if container.contains(.price) {
            self.price = try container.decode(Float.self, forKey: .price)
        } else {
            self.price = 0.0
        }
        if container.contains(.priceString) {
            self.priceString = try container.decode(String.self, forKey: .priceString)
        } else {
            self.priceString = nil
        }
        self.iconFile = try container.decode(String.self, forKey: .iconFile)
        self.developer = try container.decode(String.self, forKey: .developer)
        self.bundleIdentifier = try container.decode(String.self, forKey: .bundleIdentifier)
        self.appStoreURL = try container.decode(String.self, forKey: .appStoreURL)
        self.storeIdentifier = try container.decode(String.self, forKey: .storeIdentifier)
    }
}
