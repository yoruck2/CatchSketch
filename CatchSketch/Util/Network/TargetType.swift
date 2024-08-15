//
//  TargetType.swift
//  CatchSketch
//
//  Created by dopamint on 8/15/24.
//

import Foundation
import Alamofire
// MARK: 라우터 패턴 -
//1. Router Enum 왜 만듬?
//2. TargetType Protocol 굳이 왜 필요함?
//3. URLRequestConvertible이 뭔디
//4. asURLRequest가 하고 있는건 뭐야

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: [String: String] { get }
    var parameters: String? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var request = try URLRequest(url: url, method: method)
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        request.httpBody = parameters?.data(using: .utf8)
        return request
    }
}

