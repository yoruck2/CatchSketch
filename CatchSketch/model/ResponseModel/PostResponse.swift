//
//  PostResponse.swift
//  CatchSketch
//
//  Created by dopamint on 8/21/24.
//

import Foundation

struct PostResponse: Decodable {
    let post_id: String
    let product_id: String?
    let title: String?
    let price: String?
//    let asdf: Bool
    let content: String?
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    let createdAt: Creator
    let creator: String
      
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let hashTags: [String]
    let comments: [String]
}

struct Creator: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}

