//
//  WishListable.swift
//  WishApp
//
//  Created by Janosch Hübner on 18.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation

public protocol WishListable {
    /*
     self.appStoreURL = app.appStoreURL
     self.priceString = app.offers.first?.priceFormatted
     self.price = app.offers.first?.price ?? 0.0
     self.name = app.name
     self.developer = app.developerName
     self.storeIdentifier = app.identifier
     self.bundleIdentifier = app.bundleIdentifier
 */
    var appStoreURL: String {get}
    var priceString: String? {get}
    var price: Float {get}
    var name: String {get}
    var developer: String {get}
    var storeIdentifier: String {get}
    var bundleIdentifier: String {get}
}
