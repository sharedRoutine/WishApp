//
//  StringExtension.swift
//  WishApp
//
//  Created by Janosch Hübner on 05.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation

extension String {
    
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    public var sha1String: String {
        get {
            let data = self.data(using: String.Encoding.utf8)!
            var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
            data.withUnsafeBytes {
                _ = CC_SHA1($0, CC_LONG(data.count), &digest)
            }
            let hexBytes = digest.map { String(format: "%02hhx", $0) }
            return hexBytes.joined()
        }
    }
}
