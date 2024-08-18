//
//  NetworkService.swift
//  CatchSketch
//
//  Created by dopamint on 8/15/24.
//

import Foundation
import Alamofire
import RxSwift

struct NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    func requestC<T: Decodable>(api: Router,
                                model: T.Type) {
        
        AF.request(api)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                print(response.request)
                print("Response: \(response.response)")
                print("Result: \(response.response?.statusCode)")
                switch response.result {
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func requestSingle<T: Decodable>(api: Router,
                               model: T.Type) -> Single<Result<T, Error>> {
        return Single.create { observer in
            AF.request(api)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    print("Request: \(response.request)")
                    print("Response: \(response.response)")
                    print("Result: \(response.response?.statusCode)")
                    switch response.result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        observer(.success(.failure(error)))
                    }
                }
            return Disposables.create()
        }.debug("requestSingle")
    }
}
