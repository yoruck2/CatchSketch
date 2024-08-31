//
//  JsonEncoder+.swift
//  CatchSketch
//
//  Created by dopamint on 8/16/24.
//

import Foundation

extension JSONEncoder {
    
    static let jsonEncoder = JSONEncoder()
    
    static func encode<E: Encodable>(with query: E) throws -> Data {
        do {
            let result = try jsonEncoder.encode(query)
            return result
        } catch {
            print("인코딩 실패: \(error)")
            throw error
        }
    }
}
