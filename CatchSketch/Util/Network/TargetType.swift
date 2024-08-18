//
//  TargetType.swift
//  CatchSketch
//
//  Created by dopamint on 8/15/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
//    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension TargetType {
    
    var baseURL: String {
        return APIAuth.catchSketchAPI.baseURL + "/v1"
    }
    
    var encoding: ParameterEncoding {
            switch method {
            case .get:
                return URLEncoding.default
            default: 
                return JSONEncoding.default
            }
        }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
//        print(baseURL)
//        print(url)
        var request = try URLRequest(url: url, method: method)
        request.headers = headers
        if let body = body {
            request.httpBody = body
        }
        return try encoding.encode(request, with: parameters)
//        request.httpBody = parameters?.data(using: .utf8)
//        return request
    }
}

