//
//  NetworkService.swift
//  CatchSketch
//
//  Created by dopamint on 8/15/24.
//

import Foundation
import Alamofire
import RxSwift

class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    private func request<T: Decodable>(api: Router) -> Single<Result<T, Error>> {
        return Single.create { observer in
            AF.request(api)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    print("Request: \(String(describing: response.request))")
                    print("Result: \(String(describing: response.response?.statusCode))")
                    switch response.result {
                    case .success(let value):
                        print("✅✅✅✅✅✅✅")
                        observer(.success(.success(value)))
                    case .failure(let error):
                        guard let errorCode = error.responseCode else { return }
                        print(errorCode)
                        let apiError = self.handleError(errorCode: errorCode)
                        observer(.success(.failure(apiError)))
                    }
                }
            return Disposables.create()
        }.debug("request")
    }
    private func handleError(errorCode: Int) -> APIError {
        var error = APIError.toAPIError(errorCode)
        print(error.description)
        if error == .expiredAccessToken {
            refreshToken()
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let value):
                        UserDefaultsManager.shared.accessToken = value.accessToken
                    case .failure(let error): break
                        
                    }
                }
        }
        
        return error
    }
    
    func refreshToken() -> Single<Result<AccesToken, Error>> {
        return request(api: .auth(.tokenRefresh))
    }
    //        if let urlError = error.underlyingError as? URLError, urlError.code == .badURL {
    //            return .invalidURL
    //        }
    //        if error.isResponseSerializationError {
    //            return .decodingError
    //
}

extension NetworkService {
    func logIn(query: Router) -> Single<Result<LogInResponse, Error>> {
        return request(api: query)
    }
    func signUp(query: Router) -> Single<Result<Profile, Error>> {
        return request(api: query)
    }
}
