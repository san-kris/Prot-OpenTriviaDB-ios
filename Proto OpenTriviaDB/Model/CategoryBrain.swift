//
//  TriviaCategories.swift
//  Proto OpenTriviaDB
//
//  Created by Santosh Krishnamurthy on 2/15/23.
//

import Foundation

class CategoryBrain {
        
    var userCategories: [TriviaCategory]?
    var categoriesFromTriviaDB: TriviaDBCategories?
    
    init() {
        getCategoriesFromTriviaDB()
    }
    
    func getUserCatagories() -> [[String : Any]]? {
        // check if categories list is populated
        if let userCategories{
            return userCategories.compactMap({ category in
                category.dictionary
            })
        } else {
            // Check if user default has session object stored
            if let userCategoryData = UserDefaults.standard.object(forKey: Constant.UserDefaults.userCategoryKey) as? Data{
                do{
                    print("Categories found in User Default")
                    userCategories = try JSONDecoder().decode([TriviaCategory].self, from: userCategoryData)
                    if let userCategories{
                        return userCategories.compactMap({ category in
                            category.dictionary
                        })
                    } else {
                        return nil
                    }
                } catch {
                    print("Failed to decode Category: \(error)")
                    return nil
                }
            } else {
                // Create a new default category
                let defaultCategory = TriviaCategory(categoryID: Constant.TriviaCategory.DefaultCategory.categoryID,
                                                     difficulty: Constant.TriviaCategory.DefaultCategory.difficulty)
                // Create empty category list
                userCategories = []
                // Add new category to list
                userCategories?.append(defaultCategory)
                
                if let userCategories{
                    do{
                        // encode trivia categorie list
                        let encodedCategories = try JSONEncoder().encode(userCategories)
                        
                        // Add new categry list to UserDefaults
                        let userDefaults = UserDefaults.standard
                        // Check if user default has session object stored
                        userDefaults.set(encodedCategories, forKey: Constant.UserDefaults.userCategoryKey)
                        
                    } catch {
                        print("Failed to encode categories: \(error)")
                    }
                    
                    return userCategories.compactMap({ category in
                        category.dictionary
                    })
                } else {
                    return nil
                }
            }
            
        }
    }
    
    private func getCategoriesFromTriviaDB() -> Void{
        
        if let triviaDBCategoryMappingData = UserDefaults.standard.object(forKey: Constant.UserDefaults.triviaDBCategoryMappingKey) as? Data{
            do{
                print("Category Mapping found in User Default")
                categoriesFromTriviaDB = try JSONDecoder().decode(TriviaDBCategories.self, from: triviaDBCategoryMappingData)
                return
            } catch {
                print("Failed to decode Category: \(error)")
            }
        }
        
        // get new session ID
        print("Getting Category List from API")
        TriviaDBConnection.getData(url: Constant.TriviaCategory.categoryURL, parameters: nil) { (data, response, error) in
            if let error{
                print("Failed to get Session response: \(error)")
                return
            }
            guard let data else {
                print("Category API did not reruen data")
                return
            }
            do{
                self.categoriesFromTriviaDB = try JSONDecoder().decode(TriviaDBCategories.self, from: data)
                
                // save Data into UserDefaults
                // get the default UserDefaults object
                let userDefaults = UserDefaults.standard
                // Check if user default has session object stored
                userDefaults.set(data, forKey: Constant.UserDefaults.triviaDBCategoryMappingKey)
                
            } catch {
                print("Failed to decode Categories: \(error)")
            }
        }
    }
    
}
struct TriviaCategory: Codable {
    let categoryID: Int
    let difficulty: String
    var title: String {
        switch categoryID{
        case 9: return "General Knowledge"
        case 10: return "Entertainment: Books"
        case 11: return "Entertainment: Film"
        case 12: return "Entertainment: Music"
        case 13: return "Entertainment: Musicals & Theatres"
        case 14: return "Entertainment: Television"
        case 15: return "Entertainment: Video Games"
        case 16: return "Entertainment: Board Games"
        case 17: return "Science & Nature"
        case 18: return "Science: Computers"
        case 19: return "Science: Mathematics"
        case 20: return "Mythology"
        case 21: return "Sports"
        case 22: return "Geography"
        case 23: return "History"
        case 24: return "Politics"
        case 25: return "Art"
        case 26: return "Celebrities"
        case 27: return "Animals"
        case 28: return "Vehicles"
        case 29: return "Entertainment: Comics"
        case 30: return "Science: Gadgets"
        case 31: return "Entertainment: Japanese Anime & Manga"
        case 32: return "Entertainment: Cartoon & Animations"
        default: return "General Knowledge"
        }
    }
    var subTitle: String {
        return "Difficulty level: " + difficulty
    }
    var image: String {
        switch categoryID{
        case 9: return "brain.head.profile"
        case 10: return "book"
        case 11: return "video"
        case 12: return "music.note"
        case 13: return "theatermasks"
        case 14: return "tv"
        case 15: return "gamecontroller"
        case 16: return "checkerboard.rectangle"
        case 17: return "tree"
        case 18: return "laptopcomputer"
        case 19: return "divide"
        case 20: return "theatermasks"
        case 21: return "figure.pool.swim"
        case 22: return "mountain.2"
        case 23: return "scroll"
        case 24: return "building.columns"
        case 25: return "theatermasks"
        case 26: return "person.bust"
        case 27: return "pawprint"
        case 28: return "car"
        case 29: return "figure.archery"
        case 30: return "gauge.high"
        case 31: return "figure.fencing"
        case 32: return "figure.run"
        default: return "brain.head.profile"
        }
    }
    
    var dictionary: [String: Any] {
        return[
            "categoryID": categoryID,
            "difficulty": difficulty,
            "title": title,
            "subTitle": subTitle,
            "image": image
        ]
    }
}

extension TriviaCategory: DocumentSerializable{
    init?(dictionary: [String : Any]) {
        guard let categoryID = dictionary["categoryID"] as? Int,
              let difficulty = dictionary["difficulty"] as? String
        else {return nil}
        
        self.init(categoryID: categoryID,
                  difficulty: difficulty
        )
    }
}
