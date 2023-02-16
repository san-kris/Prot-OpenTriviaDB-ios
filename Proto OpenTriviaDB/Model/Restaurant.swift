//
//  Restaurant.swift
//  Proto OpenTriviaDB
//
//  Created by Santosh Krishnamurthy on 2/12/23.
//

import Foundation
//import Firebase


struct Restaurant {
    
    var name: String
    var category: String // Could become an enum
    var city: String
    var price: Int // from 1-3; could also be an enum
    var ratingCount: Int // numRatings
    var averageRating: Float
    
    // dictionary is a computed property and returns the object properties as a dict
    var dictionary: [String: Any] {
        return [
            "name": name,
            "category": category,
            "city": city,
            "price": price,
            "numRatings": ratingCount,
            "avgRating": averageRating,
        ]
    }
    
}

// DocumentSerializable is a protocol by Firestore which will be used to copy data into from Firestore
extension Restaurant: DocumentSerializable {
    
    // this is the method required by DocumentSerializable protocol.
    // this init methoos takes dict as input and instantiates an object
    init?(dictionary: [String : Any]) {
        // use guard let to read data from dict into local variables
        guard let name = dictionary["name"] as? String,
              let category = dictionary["category"] as? String,
              let city = dictionary["city"] as? String,
              let price = dictionary["price"] as? Int,
              let ratingCount = dictionary["numRatings"] as? Int,
              let averageRating = dictionary["avgRating"] as? Float else { return nil }
        
        // use the local variables to instantiate the class by calling self.init
        self.init(name: name,
                  category: category,
                  city: city,
                  price: price,
                  ratingCount: ratingCount,
                  averageRating: averageRating)
    }
    
}
