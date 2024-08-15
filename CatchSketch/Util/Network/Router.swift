//
//  Router.swift
//  CatchSketch
//
//  Created by dopamint on 8/15/24.
//

import Foundation
import Alamofire

enum Router {
    case join
    case login(query: LoginQuery)
    case fetchProfile
    case editProfile
    case refresh
}

extension Router: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .join:
                .post
        case .login:
                .post
        case .fetchProfile:
                .post
        case .editProfile:
                .post
        case .refresh:
                .get
        }
    }
    
    var parameters: String? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var body: Data? {
        switch self {
            
        case .login(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        default:
            return nil
        }
    }
    
    var baseURL: String {
        return APIAuth.catchSketchAPI.baseURL + "/v1"
    }
    
    var path: String {
        switch self {
        case .signUp
        case .login:
            return "/users/login"
        case .fetchProfile, .editProfile:
            return "/users/me/profile"
        case .refresh:
            return "/auth/refresh"
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .login:
            return [
                Header.contentType.rawValue : Header.json.rawValue,
                Header.sesacKey.rawValue: APIAuth.catchSketchAPI.key]
        case .fetchProfile:
            return [
                Header.authorization.rawValue: UserDefaultsManager.shared.accessToken,
                Header.contentType.rawValue : Header.json.rawValue,
                Header.sesacKey.rawValue: APIAuth.catchSketchAPI.key]
        case .editProfile:
            return [
                Header.authorization.rawValue: UserDefaultsManager.shared.accessToken,
                Header.contentType.rawValue : "multipart/form-data",
                Header.sesacKey.rawValue: APIAuth.catchSketchAPI.key]
        case .refresh:
            return [
                Header.authorization.rawValue: UserDefaultsManager.shared.accessToken,
                Header.contentType.rawValue : Header.json.rawValue,
                Header.refresh.rawValue : UserDefaultsManager.shared.refreshToken,
                Header.sesacKey.rawValue: APIAuth.catchSketchAPI.key]
        }
    }
    
}

