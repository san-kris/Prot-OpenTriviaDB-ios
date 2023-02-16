//
//  OpenTriviaDBSession.swift
//  Proto OpenTriviaDB
//
//  Created by Santosh Krishnamurthy on 2/13/23.
//

import Foundation

struct OpenTriviaDBSession: Codable {
    let code: Int
    let message: String
    let token: String
    
    private enum CodingKeys: String, CodingKey{
        case code = "response_code"
        case message = "response_message"
        case token = "token"
    }
}
