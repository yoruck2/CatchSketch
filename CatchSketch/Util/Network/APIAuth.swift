//
//  APIAuth.swift
//  CatchSketch
//
//  Created by dopamint on 8/15/24.
//

import Foundation

enum APIAuth {
    case catchSketchAPI
    
    var baseURL: String {
        let url: String
        
        switch self {
        case .catchSketchAPI:
            url = "BaseURL"
        }
        guard let url = Bundle.main.object(forInfoDictionaryKey: url) as? String else {
            assertionFailure("헤더를 찾을 수 없음")
            return ""
        }
        return url
    }
    var key: String {
        let keyName: String
        
        switch self {
        case .catchSketchAPI:
            keyName = "SesacKey"
        }
        guard let key = Bundle.main.object(forInfoDictionaryKey: keyName) as? String else {
            assertionFailure("헤더를 찾을 수 없음")
            return ""
        }
        return key
    }
}
