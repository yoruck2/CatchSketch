//
//  LogInQuery.swift
//  CatchSketch
//
//  Created by dopamint on 8/15/24.
//

import Foundation

struct AuthQuery {
    struct SignUp: Codable {
        let email: String
        let password: String
        let nick: String
    }
    struct EmailValidation: Encodable {
        let email: String
    }
    struct LogIn: Encodable {
        let email: String
        let password: String
    }
    
}

