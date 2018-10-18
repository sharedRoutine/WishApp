//
//  ShareViewController.swift
//  ImportExtension
//
//  Created by Janosch Hübner on 05.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    private var appURL: URL? = nil
    private var appImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
             
        let extensionItem = self.extensionContext?.inputItems[0] as! NSExtensionItem
        let contentTypeURL = kUTTypeURL as String
        let contentTypeImage = kUTTypeImage as String
        
        if let attachments = extensionItem.attachments {
            for attachment in attachments {
                if attachment.hasItemConformingToTypeIdentifier(contentTypeURL) {
                    attachment.loadItem(forTypeIdentifier: contentTypeURL, options: nil, completionHandler: { (results, error) in
                        if let url = results as? URL {
                            self.appURL = url
                        }
                        _ = self.isContentValid()
                    })
                }
                if attachment.hasItemConformingToTypeIdentifier(contentTypeImage) {
                    attachment.loadItem(forTypeIdentifier: contentTypeImage, options: nil) { (results, error) in
                        if let image = results as? UIImage {
                            self.appImage = image
                        }
                    }
                }
            }
        }
    }

    override func isContentValid() -> Bool {
        return self.appURL != nil && self.appImage != nil
    }

    override func didSelectPost() {
        guard let url = self.appURL else {
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        guard let image = self.appImage else {
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        ImportManager.shared.import(fromURL: url) { (item: WishListItem?) in
            if let wishListItem = item {
                if let fileName = ImageManager.shared.save(image: image, for: wishListItem.bundleIdentifier) {
                    wishListItem.imageName = fileName
                }
                DatabaseManager.shared.write(object: wishListItem)
            } else {
                // in case of safari, show error
            }
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
    }

    override func configurationItems() -> [Any]! {
        return []
    }

}
