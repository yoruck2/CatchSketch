//
//  Router.swift
//  CatchSketch
//
//  Created by dopamint on 8/15/24.
//

import Foundation
import Alamofire

enum Router {
    case auth(AuthEndpoint)
    case post(PostEndpoint)
    case profile(ProfileEndpoint)
    
    enum AuthEndpoint {
        case join(query: AuthQuery.Join)
        case login(query: AuthQuery.LogIn)
        case emailValidation(query: AuthQuery.EmailValidation)
        case refresh
    }
    
    enum PostEndpoint {
        case uploadImage(files: Post.ImageUpload)
        case create(post: Post)
        case postView(cursor: String, limit: Int)
    }
    enum ProfileEndpoint {
        case fetch
        case edit(data: Profile.Edit)
    }
}

extension Router: TargetType {
   
    var method: HTTPMethod {
        switch self {
        case .auth(let endpoint):
            switch endpoint {
            case .join, .login, .emailValidation: 
                return .post
            case .refresh: 
                return .get
            }
        case .profile(let endpoint):
            switch endpoint {
            case .fetch: 
                return .get
            case .edit:
                return .put
            }
        case .post(let endpoint):
            switch endpoint {
            case .uploadImage, .create: 
                return .post
            case .postView:
                return .get
            }
        }
    }
    
    var path: String {
        switch self {
        case .auth(let endpoint):
            switch endpoint {
            case .join: 
                return "/users/join"
            case .login:
                return "/users/login"
            case .emailValidation:
                return "/users/email"
            case .refresh:
                return "/auth/refresh"
            }
        case .profile:
            return "/users/me/profile"
        case .post(let endpoint):
            switch endpoint {
            case .uploadImage: 
                return "/posts/images"
            case .create:
                return "/posts"
            case .postView:
                return "/posts/posts"
            }
        }
    }
    
    var headers: HTTPHeaders {
        var headers: HTTPHeaders = [Header.sesacKey.rawValue: APIAuth.catchSketchAPI.key]
        
        switch self {
        case .auth(let endpoint):
            switch endpoint {
                // 안넣어도 되는지 확인
            case .join, .login, .emailValidation:
                headers[Header.contentType.rawValue] = Header.json.rawValue
            case .refresh:
                headers[Header.authorization.rawValue] = UserDefaultsManager.shared.accessToken
                headers[Header.refresh.rawValue] = UserDefaultsManager.shared.refreshToken
            }
        case .post(let endpoint):
            switch endpoint {
            case .uploadImage(_):
                headers[Header.contentType.rawValue] = Header.multiPart.rawValue
                headers[Header.authorization.rawValue] = UserDefaultsManager.shared.accessToken
            case .create(_):
                headers[Header.contentType.rawValue] = Header.json.rawValue
                headers[Header.authorization.rawValue] = UserDefaultsManager.shared.accessToken
            case .postView:
                headers[Header.authorization.rawValue] = UserDefaultsManager.shared.accessToken
            }
        case .profile(let endpoint):
            switch endpoint {
            case .fetch:
                headers[Header.authorization.rawValue] = UserDefaultsManager.shared.accessToken
            case .edit(_):
                headers[Header.authorization.rawValue] = UserDefaultsManager.shared.accessToken
                headers[Header.contentType.rawValue] = Header.multiPart.rawValue
            }
        }
        return headers
    }
    
    var parameters: Parameters? {
        switch self {
        case .auth(let endpoint):
            switch endpoint {
            case .join, .login, .emailValidation, .refresh:
                return nil
            }
        case .profile(let endpoint):
            switch endpoint {
            case .fetch:
                return nil
            case .edit:
                return nil
            }
        case .post(let endpoint):
            switch endpoint {
            case .uploadImage:
                return nil
            case .create:
                return nil
            case .postView(let cursor, let limit):
                return ["next": cursor, "limit": limit]
            }
        }
    }
    
    var body: Data? {
        switch self {
        case .auth(let endpoint):
            switch endpoint {
            case .join(let query):
                return try? JSONEncoder.encode(with: query)
            case .login(query: let query):
                return try? JSONEncoder.encode(with: query)
            case .emailValidation(query: let query):
                return try? JSONEncoder.encode(with: query)
            case .refresh:
                return nil
            }
        case .profile(let endpoint):
            switch endpoint {
            case .edit(let data):
                return try? JSONEncoder.encode(with: data)
            case .fetch:
                return nil
            }
        case .post(let endpoint):
            switch endpoint {
            case .uploadImage(let files):
                return try? JSONEncoder.encode(with: files)
            case .create(let post):
                return try? JSONEncoder.encode(with: post)
            case .postView:
                return nil
            }
        }
    }
}
