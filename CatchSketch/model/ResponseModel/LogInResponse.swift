//
//  LogInResponse.swift
//  CatchSketch
//
//  Created by dopamint on 8/17/24.
//

import Foundation

struct LogInResponse: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String
    let refreshToken: String
}
