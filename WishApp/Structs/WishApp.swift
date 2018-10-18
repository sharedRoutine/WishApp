//
//  WishApp.swift
//  WishApp
//
//  Created by Janosch Hübner on 17.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation

struct WishApp {
    static var appVersion: String {
        get {
            guard let shortVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
                return ""
            }
            guard let bundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
                return ""
            }
            return "\(shortVersionString).\(bundleVersion)"
        }
    }
}
