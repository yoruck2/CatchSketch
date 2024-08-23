//
//  Post.swift
//  CatchSketch
//
//  Created by dopamint on 8/16/24.
//

import Foundation

struct PostRequest: Encodable {
    let product_id: String?
    
    let title: String?
    let content: String?
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    
    let files: [String]?
    
    struct ImageUpload: Encodable {
        let files: [Data]
    }
    
    struct View: Encodable {
        let product_id: String?
        let next: String?
        let limit: String?
    }
}
