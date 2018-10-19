//
//  AppSearchResult.swift
//  WishApp
//
//  Created by Janosch Hübner on 18.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation

struct AppSearchResult : Decodable {
   
    let apps: [App]
    
    public var paidApps: [App] {
        return self.apps.filter({ (app: App) -> Bool in
            return !app.isFree
        })
    }
    
    enum CodingKeys: String, CodingKey {
        case apps = "results"
    }
}
