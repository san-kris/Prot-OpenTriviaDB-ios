//
//  TriviaDBCategories.swift
//  Proto OpenTriviaDB
//
//  Created by Santosh Krishnamurthy on 2/16/23.
//

import Foundation

struct TriviaDBCategories: Codable {
    let categories: [TriviaDBCategory]
    var dictionary: [String: Any]?
        
    private enum CodingKeys: String, CodingKey{
        case categories = "trivia_categories"
    }
    
    private func mapCategoryNameToID() -> [String: Any]{
        var dict: [String: Any] = [:]
        for category in categories{
            dict[String(category.categoryID)] = category.categoryName
        }
        return dict
    }
    
    func getCategoryName(forID: Int) -> String? {
        if let dictionary{
            return dictionary[String(forID)] as? String
        } else {
            return nil
        }
    }
}

struct TriviaDBCategory: Codable {
    let categoryID: Int
    let categoryName: String
    
    private enum CodingKeys: String, CodingKey{
        case categoryID = "id"
        case categoryName = "name"
    }
}
