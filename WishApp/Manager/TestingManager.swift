//
//  TestingManager.swift
//  WishApp
//
//  Created by Janosch Hübner on 29.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation

class TestingManager: NSObject {
    public static let shared: TestingManager = TestingManager()
    private override init() {}
    
    public var isTesting: Bool {
        get {
            return ProcessInfo.processInfo.arguments.contains("WISH_APP_TESTING") || ProcessInfo.processInfo.environment["WISH_APP_TESTING"] == "YES"
        }
    }
    
    public var isTestingDataPresent: Bool {
        get {
            var isDirectory: ObjCBool = false
            let testingURL: URL = Bundle.main.bundleURL.appendingPathComponent("Testing")
            if FileManager.default.fileExists(atPath: testingURL.path, isDirectory: &isDirectory) && isDirectory.boolValue {
                isDirectory = false
                if FileManager.default.fileExists(atPath: testingURL.appendingPathComponent("Icons").path, isDirectory: &isDirectory) && isDirectory.boolValue {
                    return FileManager.default.fileExists(atPath: testingURL.appendingPathComponent("Testing").appendingPathExtension("realm").path)
                }
            }
            return false
        }
    }
}
