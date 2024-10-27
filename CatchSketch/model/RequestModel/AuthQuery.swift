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
        let coin: String // 재화로 쓰임
        let exp: String
        
        enum CodingKeys: String, CodingKey {
            case email
            case password
            case nick
            case coin = "phoneNum"
            case exp = "birthDay"
        }
        
    }
    struct EmailValidation: Encodable {
        let email: String
    }
    struct LogIn: Encodable {
        let email: String
        let password: String
    }
}

