//
//  TriviaCategories.swift
//  Proto OpenTriviaDB
//
//  Created by Santosh Krishnamurthy on 2/15/23.
//

import Foundation

struct TriviaCategory: Codable {
    let title: String
    let subTitle: String
    let urlString: String
    
    var dictionary: [String: Any] {
        return[
            "title": title,
            "subTitle": subTitle,
            "urlString": urlString
        ]
    }
}

extension TriviaCategory: DocumentSerializable{
    init?(dictionary: [String : Any]) {
        guard let title = dictionary["title"] as? String,
              let subTitle = dictionary["subTitle"] as? String,
              let urlString = dictionary["urlString"] as? String
        else {return nil}
        
        self.init(title: title,
                  subTitle: subTitle,
                  urlString: urlString
        )
    }
}
