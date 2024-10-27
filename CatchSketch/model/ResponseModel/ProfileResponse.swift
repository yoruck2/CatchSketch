//
//  ProfileResponse.swift
//  CatchSketch
//
//  Created by dopamint on 10/28/24.
//

import Foundation

struct ProfileResponse: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let coin: String?
    let exp: String?
    let profileImage: String?
    let followers: [String]?
    let following: [User]?
    let post: [String]?
    
    enum CodingKeys: String, CodingKey {
        case user_id
        case email
        case nick
        case coin = "phoneNum"
        case exp = "birthDay"
        case profileImage
        case followers
        case following
        case post
    }
}

struct User: Decodable {
    let user_id: String
    let nick: String
}
