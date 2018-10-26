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

class ShareViewController: UIViewController {
    
    private var appURL: URL? = nil
    private var appImage: UIImage? = nil
    
    private var statusView: UIView!
    private var appIconImageView: UIImageView = UIImageView(frame: .zero)
    private var statusLabel: UILabel = UILabel(frame: .zero)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animateIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bounds: CGRect = UIScreen.main.bounds
        self.statusView = UIView(frame: CGRect(x: 0, y: bounds.size.height, width: bounds.width, height: 125.0))
        self.statusView.backgroundColor = UIColor.darkJungleGreen
        
        self.appIconImageView.image = self.appImage ?? UIImage(named: "DefaultIcon")
        self.appIconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.statusView.addSubview(self.appIconImageView)
        
        self.appIconImageView.centerXAnchor.constraint(equalTo: self.statusView.centerXAnchor).isActive = true
        self.appIconImageView.topAnchor.constraint(equalTo: self.statusView.topAnchor, constant: 20.0).isActive = true
        self.appIconImageView.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        self.appIconImageView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        
        self.statusLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        self.statusLabel.text = "LOADING_APP_INFO".localized
        self.statusLabel.textColor = UIColor.white
        self.statusLabel.textAlignment = .center
        self.statusLabel.translatesAutoresizingMaskIntoConstraints = false
        self.statusView.addSubview(self.statusLabel)
        
        self.statusLabel.centerXAnchor.constraint(equalTo: self.appIconImageView.centerXAnchor).isActive = true
        self.statusLabel.topAnchor.constraint(equalTo: self.appIconImageView.bottomAnchor, constant: 10.0).isActive = true
        self.statusLabel.widthAnchor.constraint(equalTo: self.statusView.widthAnchor).isActive = true
        self.statusLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10.0).isActive = true
        
        self.view.addSubview(self.statusView)
        
        guard let extensionItem = self.extensionContext?.inputItems.first as? NSExtensionItem else {
            self.animateOut()
            return
        }
        
        let contentTypeURL = kUTTypeURL as String
        let contentTypeImage = kUTTypeImage as String
        
        if let attachments = extensionItem.attachments {
            for attachment in attachments {
                if attachment.hasItemConformingToTypeIdentifier(contentTypeURL) {
                    attachment.loadItem(forTypeIdentifier: contentTypeURL, options: nil, completionHandler: { (results, error) in
                        if let url = results as? URL {
                            self.appURL = url
                            self.loadAppInfo()
                        } else {
                            self.statusLabel.text = "NO_URL_FOUND".localized
                        }
                    })
                }
                if attachment.hasItemConformingToTypeIdentifier(contentTypeImage) {
                    attachment.loadItem(forTypeIdentifier: contentTypeImage, options: nil) { (results, error) in
                        if let image = results as? UIImage {
                            self.appImage = image
                            DispatchQueue.main.async {
                                self.appIconImageView.image = self.appImage
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.appIconImageView.image = UIImage(named: "DefaultIcon")
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func animateIn() {
        let bounds: CGRect = UIScreen.main.bounds
        var frame = self.statusView.frame
        frame.origin.y = bounds.size.height - frame.height
        UIView.animate(withDuration: 0.3) {
            self.statusView.frame = frame
        }
    }
    
    private func animateOut() {
        let bounds: CGRect = UIScreen.main.bounds
        var frame = self.statusView.frame
        frame.origin.y = bounds.size.height
        UIView.animate(withDuration: 0.3, delay: 1.0, options: .curveEaseInOut, animations: {
            self.statusView.frame = frame
        }) { (finished: Bool) in
            if finished {
                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            }
        }
    }

    public func loadAppInfo() {
        guard let url = self.appURL else {
            self.animateOut()
            return
        }
        ImportManager.shared.import(fromURL: url) { (item: WishListItem?) in
            if let wishListItem = item {
                
                if let image = self.appImage, let fileName = ImageManager.shared.save(image: image, for: wishListItem.bundleIdentifier) {
                    wishListItem.imageName = fileName
                } else {
                    wishListItem.imageName = "default"
                }
                
                self.statusLabel.text = "APP_ADDED_TO_WISHLIST".localized
                DatabaseManager.shared.write(object: wishListItem)
                
                self.animateOut()
            } else {
                self.statusLabel.text = "NO_VALID_APP_FOUND".localized
                self.animateOut()
            }
        }
    }
}
