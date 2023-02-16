//
//  Trivia.swift
//  Proto OpenTriviaDB
//
//  Created by Santosh Krishnamurthy on 2/11/23.
//

import Foundation

//MARK: - DocumentSerializable defenition

// A type that can be initialized from a Firestore document.
protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}

//MARK: - Trivia Defenition

struct Trivia: Codable {
    let responseCode: Int
    let questions: [Question]
    
    var dictionary: [String: Any] {
        return [
            "responseCode": responseCode,
            "questions": questions.compactMap({ question in
                question.dictionary
            })
        ]
    }
    
    private enum CodingKeys: String, CodingKey{
        case responseCode = "response_code"
        case questions = "results"
    }
}

extension Trivia: DocumentSerializable{
    init?(dictionary: [String : Any]) {
        guard let responseCode = dictionary["responseCode"] as? Int,
              let questions = dictionary["questions"] as? [[String: Any]]
        else {return nil}
        let questionsObjs = questions.compactMap({ question in
            Question(dictionary: question)
        })
        self.init(responseCode: responseCode, questions: questionsObjs)
    }
}

//MARK: - Question defenition

struct Question: Codable {
    let q: String
    let ans: String
    let otherChoices: [String]
    let category: String
    let type: String
    let difficulty: String
    
    var dictionary: [String: Any] {
        return [
            "q": q,
            "ans": ans,
            "otherChoices": otherChoices,
            "category": category,
            "type": type,
            "difficulty": difficulty
        ]
    }
    
    private enum CodingKeys: String, CodingKey{
        case q = "question"
        case ans = "correct_answer"
        case otherChoices = "incorrect_answers"
        case difficulty
        case category
        case type
    }
}

extension Question: DocumentSerializable{
    init?(dictionary: [String : Any]) {
        guard let q = dictionary["q"] as? String,
              let ans = dictionary["ans"] as? String,
              let otherChoices = dictionary["otherChoices"] as? [String],
              let category = dictionary["category"] as? String,
              let type = dictionary["type"] as? String,
              let difficulty = dictionary["difficulty"] as? String
        else { return nil}
        
        self.init(q: q,
                  ans: ans,
                  otherChoices: otherChoices,
                  category: category,
                  type: type,
                  difficulty: difficulty
        )
    }
}
