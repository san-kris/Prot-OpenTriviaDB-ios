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
    
    static let categoryOptions: [[String:Any]] = [
        ["id":9, "name":"General Knowledge"],
        ["id":10, "name":"Entertainment: Books"],
        ["id":11, "name":"Entertainment: Film"],
        ["id":12, "name":"Entertainment: Music"],
        ["id":13, "name":"Entertainment: Musicals & Theatres"],
        ["id":14, "name":"Entertainment: Television"],
        ["id":15, "name":"Entertainment: Video Games"],
        ["id":16, "name":"Entertainment: Board Games"],
        ["id":17, "name":"Science & Nature"],
        ["id":18, "name":"Science & Nature"],
        ["id":19, "name":"Science: Mathematics"],
        ["id":20, "name":"Mythology"],
        ["id":21, "name":"Sports"],
        ["id":22, "name":"Geography"],
        ["id":23, "name":"History"],
        ["id":24, "name":"Politics"],
        ["id":25, "name":"Art"],
        ["id":26, "name":"Celebrities"],
        ["id":27, "name":"Animals"],
        ["id":28, "name":"Vehicles"],
        ["id":29, "name":"Entertainment: Comics"],
        ["id":30, "name":"Science: Gadgets"],
        ["id":31, "name":"Entertainment: Japanese Anime & Manga"],
        ["id":32, "name":"Entertainment: Cartoon & Animations"]
    ]
        
    
    static func getCategoryName(forID: Int) -> String? {
        for category in categoryOptions{
            if forID == category["id"] as? Int {
                return category["name"] as? String
            }
        }
        return nil
    }
    
    static func getCategoryID(forName: String) -> Int? {
        for category in categoryOptions{
            if forName == category["name"] as? String {
                return category["id"] as? Int
            }
        }
        return nil
    }
    
    static func getAllCategories() -> [String]? {
        return categoryOptions.compactMap { category in
            category["name"] as? String
        }
    }
    
    private func mapCategoryNameToID() -> [String: Any]{
        var dict: [String: Any] = [:]
        for category in categories{
            dict[String(category.categoryID)] = category.categoryName
        }
        return dict
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
