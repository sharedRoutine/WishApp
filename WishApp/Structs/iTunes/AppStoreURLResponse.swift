//
//  AppStoreURLResponse.swift
//  WishApp
//
//  Created by Janosch Hübner on 07.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation

struct AppStoreURLResponse : Decodable {
    
    let apps: [URLApp]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let storePlatformDataContainer = try container.nestedContainer(keyedBy: StorePlatformDataKeys.self, forKey: .storePlatformData)
        let productDVContainer = try storePlatformDataContainer.nestedContainer(keyedBy: ProductDVKeys.self, forKey: .productDV)
        let results: [String : URLApp] = try productDVContainer.decode([String : URLApp].self, forKey: .results)
        let apps: [URLApp] = Array(results.values)
        self.apps = apps
    }
    
    enum CodingKeys: String, CodingKey {
        case storePlatformData
    }
    
    enum StorePlatformDataKeys: String, CodingKey {
        case productDV = "product-dv"
    }
    
    enum ProductDVKeys: String, CodingKey {
        case results
    }
}
