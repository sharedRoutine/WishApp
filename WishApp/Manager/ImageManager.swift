//
//  ImageManager.swift
//  WishApp
//
//  Created by Janosch Hübner on 07.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation
import UIKit

class ImageManager: NSObject {
    public static let shared: ImageManager = ImageManager()
    private override init() {}
    
    public var iconsURL: URL? {
        get {
            return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.sharedroutine.wishapp")?.appendingPathComponent("Library/Caches/Icons")
        }
    }
    
    public func save(image: UIImage, for bundleID: String) -> String? {
        if let iconsURL = self.iconsURL {
            var isDir: ObjCBool = false
            if !FileManager.default.fileExists(atPath: iconsURL.path, isDirectory: &isDir) || !isDir.boolValue {
               try? FileManager.default.createDirectory(at: iconsURL, withIntermediateDirectories: true, attributes: nil)
            }
            let fileName: String = bundleID.sha1String + ".png"
            let fileURL: URL = iconsURL.appendingPathComponent(fileName)
            if let data = image.pngData() {
                do {
                    try data.write(to: fileURL)
                    return fileName
                } catch {
                    print("Error writing image: \(error)")
                }
            }
        }
        return nil
    }
}
