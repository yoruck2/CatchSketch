//
//  PostResponse.swift
//  CatchSketch
//
//  Created by dopamint on 8/21/24.
//

import Foundation

struct PostResponse: Decodable {
    let data: [Post]
    let next_cursor: String?
    
    struct Post: Decodable {
        let post_id: String?
        let product_id: String?
        let title: String?
        let content: String?
        let content1: String?
        let content2: String?
        let content3: String?
        let content4: String?
        let content5: String?
        let createdAt: String?
        let creator: Creator?
        
        let files: [String]?
        let likes: [String]?
        let likes2: [String]?
        let hashTags: [String]?
        let comments: [Comment]?
    }

    struct Comment: Codable {
        let comment_id: String?
        let content: String?
        let createdAt: String
        let creator: Creator?
    }

    struct Creator: Codable {
        let user_id: String?
        let nick: String?
        let profileImage: String?
    }
}

struct ImageUploadResponse: Decodable {
    let files: [String]
}
