//
//  ImportManager.swift
//  WishApp
//
//  Created by Janosch Hübner on 07.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation

class ImportManager: NSObject {
    public static let shared: ImportManager = ImportManager()
    private override init() {}
    
    public func `import`(fromURL url: URL, withCompletion completion: @escaping (_ item: WishListItem?)->()) -> Void {
        var request: URLRequest = URLRequest(url: url)
        request.setValue("AppStore/3.0 iOS/10.0 model/iPhone8,1 (6; dt:89)", forHTTPHeaderField: "User-Agent")
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard let responseData = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            do {
                let appStoreResponse: AppStoreURLResponse = try JSONDecoder().decode(AppStoreURLResponse.self, from: responseData)
                if let app = appStoreResponse.apps.first {
                    let item: WishListItem = WishListItem(with: app)
                    DispatchQueue.main.async {
                        completion(item)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}
