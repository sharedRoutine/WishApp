//
//  NotificationNames.swift
//  WishApp
//
//  Created by Janosch Hübner on 28.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let sortOptionDidChange: NSNotification.Name = NSNotification.Name("SortOptionDidChangeNotification")
    static let needsWishListRefresh: NSNotification.Name = NSNotification.Name("WishListNeedsRefreshingNotification")
}
