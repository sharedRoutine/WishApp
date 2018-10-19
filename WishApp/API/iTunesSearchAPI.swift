//
//  iTunesSearchAPI.swift
//  WishApp
//
//  Created by Janosch Hübner on 18.10.18.
//  Copyright © 2018 Janosch Hübner. All rights reserved.
//

import Foundation

class iTunesSearchAPI: NSObject {
    
    public static let shared: iTunesSearchAPI = iTunesSearchAPI()
    private override init() {}
    
    private var searchTask: URLSessionDataTask? = nil
    
    private let baseURL: URL = URL(string: "https://itunes.apple.com/search")!
    
    public var apiURL: URL {
        get {
            return self.baseURL
        }
    }
    
    // https://itunes.apple.com/search?media=software&term=Doodle%20Jump&limit=10&country=DE&lang=de_DE
    
    private func generateAppSearchURL(for term: String, limit: Int = 10) -> URL {
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "media", value: "software")]
        queryItems.append(URLQueryItem(name: "term", value: term))
        queryItems.append(URLQueryItem(name: "limit", value: String(limit))) 
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            queryItems.append(URLQueryItem(name: "country", value: countryCode))
        }
        queryItems.append(URLQueryItem(name: "lang", value: Locale.current.identifier.lowercased()))
        var components: URLComponents = URLComponents(url: self.apiURL, resolvingAgainstBaseURL: false)!
        components.queryItems = queryItems
        return components.url!
    }
    
    public func loadApps(for text: String, limit: Int = 10, completion: @escaping ((_ result: AppSearchResult?)->())) {
        let url: URL = self.generateAppSearchURL(for: text, limit: limit)
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Swift.Error?) in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            if let data = data {
                do {
                    let jsonData: AppSearchResult = try JSONDecoder().decode(AppSearchResult.self, from: data)
                    DispatchQueue.main.async {
                        completion(jsonData)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    print("Error decoding json: \(error)")
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}

