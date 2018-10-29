//
//  WishListable.swift
//  WishApp
//
//  Created by Janosch Hübner on 18.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation

public protocol WishListable {
    var appStoreURL: String {get}
    var price: Float {get}
    var name: String {get}
    var developer: String {get}
    var storeIdentifier: String {get}
    var bundleIdentifier: String {get}
}
