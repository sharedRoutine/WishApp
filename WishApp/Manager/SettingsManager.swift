//
//  SettingsManager.swift
//  WishApp
//
//  Created by Janosch Hübner on 25.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class SettingsManager: NSObject {
    public static let shared: SettingsManager = SettingsManager()
    private override init() {}
    
    public var darkModeEnabled: Bool {
        get {
            return Defaults[.darkModeEnabled]
        }
        set {
            Defaults[.darkModeEnabled] = newValue
        }
    }
    
    public func toggle(darkMode: Bool) {
        self.darkModeEnabled = darkMode
        
        if self.darkModeEnabled {
            // enable dark mode - send notification
        } else {
            // disable dark mode - send notification
        }
    }
}
