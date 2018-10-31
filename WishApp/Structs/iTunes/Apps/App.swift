//
//  App.swift
//  WishApp
//
//  Created by Janosch Hübner on 18.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation

class App : iTunesApp, WishListable {
    
    let price: Float
    let iconFile: String
    
    public var isFree: Bool {
        return self.price <= 0.0
    }
    
    enum AppCodingKeys: String, CodingKey {
        case price
        case iconFile = "artworkUrl100"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AppCodingKeys.self)
        if container.contains(.price) {
            self.price = try container.decode(Float.self, forKey: .price)
        } else {
            self.price = 0.0
        }
        self.iconFile = try container.decode(String.self, forKey: .iconFile)
        try super.init(from: decoder)
    }
}
