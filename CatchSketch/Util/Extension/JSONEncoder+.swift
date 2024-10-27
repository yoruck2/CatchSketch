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
extension JSONDecoder {
    
    static let jsonDecoder = JSONDecoder()
    
    static func decode<D: Decodable>(_ type: D.Type, from data: Data) throws -> D {
        do {
            let result = try jsonDecoder.decode(type, from: data)
            return result
        } catch {
            print("디코딩 실패: \(error)")
            throw error
        }
    }
}
