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
    let
    private init() {}
    
    func fetchJokeWithResult() -> Single<Result<Joke, AFError>> {
        return Single.create { observer in
            AF.request(self.url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Joke.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        observer(.success(.failure(error)))
                    }
                }
            return Disposables.create()
        }.debug("JOKE API 통신")
    }
    
    func request<T: Decodable>(api: APIRouter,
                               model: T.Type,
                               completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(api)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
//                    dump(value)
                    print("성공")
                case .failure(let error):
                    completion(.failure(error))
                    print("실패")
                    dump(error)
                }
            }
    }
}
