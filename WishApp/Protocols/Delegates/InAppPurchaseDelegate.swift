//
//  InAppPurchaseDelegate.swift
//  WishApp
//
//  Created by Janosch Hübner on 07.11.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import StoreKit

protocol InAppPurchaseDelegate {
    func manager(manager: InAppPurchaseManager, didLoad products: [SKProduct]) -> Void
    func managerDidRegisterPurchase(manager: InAppPurchaseManager) -> Void
}
