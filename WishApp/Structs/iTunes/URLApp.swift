//
//  URLApp.swift
//  WishApp
//
//  Created by Janosch Hübner on 07.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation

struct URLApp : Decodable, WishListable {
    
    var price: Float {
        return self.offers.first?.price ?? 0.0
    }
    
    let storeIdentifier: String
    let developer: String
    let appStoreURL: String
    let bundleIdentifier: String
    let name: String
    
    struct Offer : Decodable {
        let priceFormatted: String
        let price: Float
        
        enum CodingKeys: String, CodingKey {
            case priceFormatted
            case price
        }
    }
    
    let offers: [Offer]
    
    enum CodingKeys: String, CodingKey {
        case name
        case developer = "artistName"
        case bundleIdentifier = "bundleId"
        case storeIdentifier = "id"
        case appStoreURL = "url"
        case offers
    }
}
