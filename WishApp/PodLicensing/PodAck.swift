//
//  PodAck.swift
//  WishApp
//
//  Created by Janosch Hübner on 03.11.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation

struct PodAck: Decodable {
    let licenses: [PodLicense]
    
    enum CodingKeys: String, CodingKey {
        case licenses = "PreferenceSpecifiers"
    }
}
