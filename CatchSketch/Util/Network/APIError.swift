//
//  APIError.swift
//  CatchSketch
//
//  Created by dopamint on 8/19/24.
//

import Foundation
import Alamofire

enum APIError: Int, Error {
    
    // MARK: 공통에러 -
    case invalidKey = 420
    case overRequest = 429
    case invalidURL = 444
    case serverError = 500
    // MARK: 토큰 -
    case invalidToken = 401
    case expiredAccessToken = 419
    case expiredRefreshToken = 418
    
    
    var description: String {
        switch self {
        case .invalidKey: return "Invalid API key"
        case .overRequest: return "Too many requests"
        case .invalidURL: return "Invalid URL"
        case .serverError: return "Server error"
        case .invalidToken: return "인증할 수 없는 토큰입니다."
        case .expiredAccessToken: return "엑세스토큰 만료"
        case .expiredRefreshToken: return "리프레쉬토큰 만료"
        }
    }
    
    static func toAPIError(_ statusCode: Int) -> APIError {
            return APIError(rawValue: statusCode) ?? .serverError
        }
}

