//
//  Constants.swift
//  Proto OpenTriviaDB
//
//  Created by Santosh Krishnamurthy on 2/14/23.
//

import Foundation

enum Constant{
    enum UserDefaults {
        static let userCategoryKey = "UserCategories"
        static let sessionIDKey = "TDBSessonID"
        static let triviaDBCategoryMappingKey = "TDBCategories"
    }
    enum TriviaSession {
        static let successCode = 0
        static let successMessage = "Session Retrieved"
        static let newSessionURL = "https://opentdb.com/api_token.php?command=request"
    }
    enum TriviaCategory {
        enum DefaultCategory {
            static let categoryID = 9
            static let categoryName = "General Knowledge"
            static let difficulty = "easy"
        }
        static let categoryURL = "https://opentdb.com/api_category.php"
    }
    enum TriviaQuestion {
        static let successCode = 0
        static let questionListURL = "https://opentdb.com/api.php"
        static let defaultQuestionCount = "20"
        static let defaultCategory = "9"
        static let defaultDifficulty = "easy"
    }

}
