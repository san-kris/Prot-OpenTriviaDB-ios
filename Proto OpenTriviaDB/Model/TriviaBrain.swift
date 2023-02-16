//
//  TriviaBrain.swift
//  Proto OpenTriviaDB
//
//  Created by Santosh Krishnamurthy on 2/14/23.
//

import Foundation

class TriviaBrain{
    static var brain = TriviaBrain()
    
    private var triviaSession: OpenTriviaDBSession?
    private var triviaCategories: [TriviaCategory]?
    private var triviaQuestions: Trivia?
    
    private init() {}
    
    func getSession() -> String?{
        
        // If triviaSession is not nill, then get the session ID from instance
        if let triviaSession{
            return triviaSession.token
        } else {
            // get the default UserDefaults object
            let userDefaults = UserDefaults.standard
            // Check if user default has session object stored
            if let triviaSessionData = userDefaults.object(forKey: Constant.UserDefaults.sessionIDKey) as? Data{
                do{
                    print("Session found in User Default")
                    triviaSession = try JSONDecoder().decode(OpenTriviaDBSession.self, from: triviaSessionData)
                    return triviaSession?.token
                } catch {
                    print("Failed to decode Session: \(error)")
                    return nil
                }
            } else {
                // Make API Call to get new Trivia Session
                getNewTriviaSession()
                return nil
            }
        }
    }
    
    func getCatagories() -> [[String : Any]]? {
        // check if categories list is populated
        if let triviaCategories{
            return triviaCategories.compactMap({ category in
                category.dictionary
            })
        } else {
            // get the default UserDefaults object
            let userDefaults = UserDefaults.standard
            // Check if user default has session object stored
            if let triviaCategoryData = userDefaults.object(forKey: Constant.UserDefaults.categoryKey) as? Data{
                do{
                    print("Categories found in User Default")
                    triviaCategories = try JSONDecoder().decode([TriviaCategory].self, from: triviaCategoryData)
                    if let triviaCategories{
                        return triviaCategories.compactMap({ category in
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
                let defaultCategory = TriviaCategory(title: Constant.TriviaCategory.DefaultCategory.title,
                                                     subTitle: Constant.TriviaCategory.DefaultCategory.subTitle,
                                                     urlString: Constant.TriviaCategory.DefaultCategory.url)
                // Create empty category list
                triviaCategories = []
                // Add new category to list
                triviaCategories?.append(defaultCategory)
                
                if let triviaCategories{
                    // encode trivia categorie list
                    let encodedCategories = encodeData(data: triviaCategories)
                    
                    // Add new categry list to UserDefaults
                    let userDefaults = UserDefaults.standard
                    // Check if user default has session object stored
                    userDefaults.set(encodedCategories, forKey: Constant.UserDefaults.categoryKey)

                    return triviaCategories.compactMap({ category in
                        category.dictionary
                    })
                } else {
                    return nil
                }
            }
            
        }
    }
    
    private func getNewTriviaSession() -> Void{
        // get new session ID
        print("Getting new session from API")
        
        TriviaDBConnection.getData(url: Constant.TriviaSession.newSessionURL, parameters: nil, completionHandler: sessionApiResponseHandler(data:response:error:))
        
    }
    
    private func sessionApiResponseHandler(data: Data?, response: URLResponse?, error: Error?) -> Void{
        if let error{
            print("Failed to get Session response: \(error)")
            return
        }
        guard let data else {
            print("Session API did not reruen data")
            return
        }
        if let newTriviaSession = decodeData(objectClass: OpenTriviaDBSession.self, data: data){
            triviaSession = newTriviaSession
            // save Data into UserDefaults
            // get the default UserDefaults object
            let userDefaults = UserDefaults.standard
            // Check if user default has session object stored
            userDefaults.set(data, forKey: Constant.UserDefaults.sessionIDKey)
              
            return
        } else{
            print("Failed to decode Session")
            return
        }
//        do{
//            // decode Data into Trivia session object
//            triviaSession = try JSONDecoder().decode(OpenTriviaDBSession.self, from: data)
//
//
//            // save Data into UserDefaults
//            // get the default UserDefaults object
//            let userDefaults = UserDefaults.standard
//            // Check if user default has session object stored
//            userDefaults.set(data, forKey: Constant.UserDefaults.sessionIDKey)
//
//            return
//        } catch {
//            print("Failed to decode Session")
//            return
//        }
    }
    
    private func decodeData<T: Decodable>(objectClass: T.Type, data: Data) -> T?{
        // 1. create a JSON decoder
        let decoder = JSONDecoder()
        
        do{
            // 2. decode Data
            let decodedObject = try decoder.decode(objectClass, from: data)
            return decodedObject

        } catch {
            print("Failed to decode object: \(error)")
            return nil
        }
    }
    
    private func encodeData<T: Encodable>(data: T) -> Data?{
        // 1. create a JSON encoder
        let encoder = JSONEncoder()
        
        do{
            // 2. decode Data
            let encodedData = try encoder.encode(data)
            return encodedData

        } catch {
            print("Failed to decode object: \(error)")
            return nil
        }
    }
}
