//
//  Profile.swift
//  CatchSketch
//
//  Created by dopamint on 8/17/24.
//

import Foundation

struct ProfileRequest: Codable {
    
    struct Edit: Codable {
        let nick: String?
        let coin: String?
        let exp: String?
        let profile: Data?
        
        enum CodingKeys: String, CodingKey {

            case nick
            case coin = "phoneNum"
            case exp = "birthDay"
            case profile
        }
    }
}
