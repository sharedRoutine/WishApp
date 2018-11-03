//
//  PodLicense.swift
//  WishApp
//
//  Created by Janosch Hübner on 03.11.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation

struct PodLicense: Decodable {
    let title: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case content = "FooterText"
    }
}
