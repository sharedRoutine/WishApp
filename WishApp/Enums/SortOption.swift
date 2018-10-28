//
//  SortOption.swift
//  WishApp
//
//  Created by Janosch Hübner on 28.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

enum SortOption: Int, CaseIterable, Equatable, DefaultsSerializable {
    case byDate
    case byName
    case byPrice
}
