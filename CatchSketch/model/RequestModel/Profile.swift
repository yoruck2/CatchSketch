//
//  Profile.swift
//  CatchSketch
//
//  Created by dopamint on 8/17/24.
//

import Foundation

struct Profile: Codable {
    
    struct Edit: Encodable {
        let nick: String?
        let phoneNum: String?
        let birthDay: String?
        let profile: Data?
    }
}
