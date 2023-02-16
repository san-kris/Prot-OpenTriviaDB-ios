//
//  Constants.swift
//  Proto OpenTriviaDB
//
//  Created by Santosh Krishnamurthy on 2/14/23.
//

import Foundation

enum Constant{
    enum UserDefaults {
        static let categoryKey = "TDBCategories"
        static let sessionIDKey = "TDBSessonID"
    }
    enum TriviaSession {
        static let successCode = 0
        static let successMessage = "Session Retrieved"
        static let newSessionURL = "https://opentdb.com/api_token.php?command=request"
    }
    enum TriviaCategory {
        enum DefaultCategory {
            static let title = "General Knowkedge"
            static let subTitle = "Difficulty: Medium"
            static let url = "https://opentdb.com/api.php?amount=20&category=9&difficulty=easy"
        }
        static let questionListURL = "https://opentdb.com/api.php"
        static let defaultQuestionCount = "20"
        static let defaultCategory = "9"
        static let defaultDifficulty = "easy"
    }
    enum TriviaQuestion {
        static let successCode = 0
        static let questionListURL = "https://opentdb.com/api.php"
        static let defaultQuestionCount = "20"
        static let defaultCategory = "9"
        static let defaultDifficulty = "easy"
    }

}
