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
        case SignUp(query: AuthQuery.SignUp)
        case login(query: AuthQuery.LogIn)
        case emailValidation(query: AuthQuery.EmailValidation)
        case tokenRefresh
    }
    
    enum PostEndpoint {
        case uploadImage(files: Data)
        case create(post: PostRequest)
        case postView(productID: String? = "", cursor: String? = "", limit: String? = "")
        case specificView(postID: String)
        case like(postID: String, isLike: Like)
        case postComment(comment: PostRequest.Comment, postID: String)
    }
    enum ProfileEndpoint {
        case fetch
        case edit(data: ProfileRequest.Edit)
    }
}

extension Router: TargetType {
   
    var method: HTTPMethod {
        switch self {
        case .auth(let endpoint):
            switch endpoint {
            case .SignUp, .login, .emailValidation: 
                return .post
            case .tokenRefresh: 
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
            case .uploadImage, .create, .postComment, .like:
                return .post
            case .postView, .specificView:
                return .get
            }
        }
    }
    
    var path: String {
        switch self {
        case .auth(let endpoint):
            switch endpoint {
            case .SignUp:
                return "/users/join"
            case .login:
                return "/users/login"
            case .emailValidation:
                return "/users/email"
            case .tokenRefresh:
                return "/auth/refresh"
            }
        case .profile:
            return "/users/me/profile"
        case .post(let endpoint):
            switch endpoint {
            case .uploadImage:
                return "/posts/files"
            case .postView, .create:
                return "/posts"
            case .specificView(let postID):
                return "/posts/\(postID)"
            case .postComment( _, let postID):
                return "/posts/\(postID)/comments"
            case .like(let postID, _):
                return "/posts/\(postID)/like"
            }
        }
    }
    
    var headers: HTTPHeaders {
        var headers: HTTPHeaders = [Header.sesacKey.rawValue: APIAuth.catchSketchAPI.key]
        
        switch self {
        case .auth(let endpoint):
            switch endpoint {
            case .SignUp, .login, .emailValidation:
                headers[Header.contentType.rawValue] = Header.json.rawValue
            case .tokenRefresh:
                headers[Header.contentType.rawValue] = Header.json.rawValue
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
                headers[Header.contentType.rawValue] = Header.json.rawValue
                headers[Header.authorization.rawValue] = UserDefaultsManager.shared.accessToken
            case .postComment(comment: let comment, postID: let postID):
                headers[Header.contentType.rawValue] = Header.json.rawValue
                headers[Header.authorization.rawValue] = UserDefaultsManager.shared.accessToken
            case .specificView(postID: let postID):
                headers[Header.contentType.rawValue] = Header.json.rawValue
                headers[Header.authorization.rawValue] = UserDefaultsManager.shared.accessToken
            case .like(postID: let postID):
                headers[Header.contentType.rawValue] = Header.json.rawValue
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
            case .SignUp, .login, .emailValidation, .tokenRefresh:
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
            case .uploadImage, .postComment, .create, .specificView, .like:
                return nil
            case .postView(let productID, let cursor, let limit):
                return ["product_id": productID ?? "", "next": cursor ?? "", "limit": limit ?? ""]
            }
        }
    }
    var body: Data? {
        switch self {
        case .auth(let endpoint):
            switch endpoint {
            case .SignUp(let query):
                return try? JSONEncoder.encode(with: query)
            case .login(query: let query):
                return try? JSONEncoder.encode(with: query)
            case .emailValidation(query: let query):
                return try? JSONEncoder.encode(with: query)
            case .tokenRefresh:
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
            case .postView, .specificView:
                return nil
            case .postComment(let comment, let postID):
                return try? JSONEncoder.encode(with: comment)
            case .like(let postID, let isLike):
                return try? JSONEncoder.encode(with: isLike)
            }
        }
    }
}
