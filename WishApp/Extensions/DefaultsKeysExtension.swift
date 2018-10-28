//
//  DefaultsKeysExtension.swift
//  WishApp
//
//  Created by Janosch Hübner on 25.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import SwiftyUserDefaults

extension DefaultsKeys {
    static let darkModeKey = DefaultsKey<Bool>("darkModeEnabled", defaultValue: true)
    static let sortOptionKey = DefaultsKey<SortOption>("sortOption", defaultValue: SortOption.byName)
}
