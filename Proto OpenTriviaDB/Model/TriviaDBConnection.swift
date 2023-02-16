//
//  TriviaDBConnection.swift
//  Proto OpenTriviaDB
//
//  Created by Santosh Krishnamurthy on 2/15/23.
//

import Foundation

struct TriviaDBConnection {
    static func getData(url: String, parameters: [String: Any]?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void{
        // 1. create URL endpoint
        var urlComp = URLComponents(string: url)
        
        // 2. iterate through URL properties and construct the GET url
        if let parameters = parameters{
            var queryItems: [URLQueryItem] = []
            for (key, value) in parameters{
                let queryItem = URLQueryItem(name: key, value: value as? String)
                queryItems.append(queryItem)
            }
            urlComp?.queryItems = queryItems
        }
        guard let finalURL = urlComp?.url else {
            print("URLComponent failed to create URL")
            return
        }
        print(finalURL)
        
        // 3. create Sessioon Tas
        let dataTask = URLSession.shared.dataTask(with: finalURL, completionHandler: completionHandler)
        
        // 4. Resume Task
        dataTask.resume()
    }
    
    
}