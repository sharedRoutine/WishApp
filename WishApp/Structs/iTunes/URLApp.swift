//
//  URLApp.swift
//  WishApp
//
//  Created by Janosch Hübner on 07.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation

struct URLApp : Decodable, WishListable {
    
    var priceString: String? {
        return self.offers.first?.priceFormatted
    }
    
    var price: Float {
        return self.offers.first?.price ?? 0.0
    }
    
    var storeIdentifier: String {
        return self.identifier
    }
    
    let developer: String
    let appStoreURL: String
    let bundleIdentifier: String
    
    struct Offer : Decodable {
        let priceFormatted: String
        let price: Float
        
        enum CodingKeys: String, CodingKey {
            case priceFormatted
            case price
        }
    }
    
    let name: String
    let identifier: String
    let offers: [Offer]
    
    enum CodingKeys: String, CodingKey {
        case name
        case developer = "artistName"
        case bundleIdentifier = "bundleId"
        case identifier = "id"
        case appStoreURL = "url"
        case offers
    }
}
