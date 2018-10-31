//
//  URLApp.swift
//  WishApp
//
//  Created by Janosch Hübner on 07.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation

class URLApp : iTunesApp, WishListable {
    
    var price: Float {
        return self.offers.first?.price ?? 0.0
    }
    
    struct Offer : Decodable {
        let price: Float
        
        enum CodingKeys: String, CodingKey {
            case price
        }
    }
    
    let offers: [Offer]
    
    enum URLAppCodingKeys: String, CodingKey {
        case offers
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: URLAppCodingKeys.self)
        
        self.offers = try container.decode([Offer].self, forKey: .offers)
        
        try super.init(from: decoder)
    }
}
