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
    
    var storeIdentifier: String {
        return "\(storeID)"
    }
    
    let name: String
    let price: Float
    let iconFile: String
    let storeID: Int
    
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
        case storeID = "trackId"
    }
}
