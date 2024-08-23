//
//  NetworkService.swift
//  CatchSketch
//
//  Created by dopamint on 8/15/24.
//

import Alamofire
import RxSwift
import UIKit

class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    var refreshTokenExpired: (() -> Void)?
    
    private func request<T: Decodable>(api: Router) -> Single<Result<T, Error>> {
        return Single.create { observer in
            AF.request(api)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    print("Request: \(String(describing: response.request))")
                    print("Response: \(String(describing: response.response))")
                    print("Result: \(String(describing: response.result))")
                    
                    //                    if let data = response.data, let str = String(data: data, encoding: .utf8) {
                    //                        print("Response Data: \(str)")
                    //                    }
                    
                    switch response.result {
                    case .success(let value):
                        print("✅✅✅✅✅✅✅")
                        observer(.success(.success(value)))
                    case .failure(let error):
                        print("❌❌❌❌❌❌❌")
                        print("Error: \(error)")
                        if let data = response.data, let str = String(data: data, encoding: .utf8) {
                            print("Error Response Data: \(str)")
                        }
                        guard let errorCode = error.responseCode else {
                            observer(.success(.failure(error)))
                            return
                        }
                        print("Error Code: \(errorCode)")
                        let apiError = self.handleError(errorCode: errorCode)
                        observer(.success(.failure(apiError)))
                    }
                }
            return Disposables.create()
        }/*.debug("request")*/
    }
    
    private func handleError(errorCode: Int) -> APIError {
        let error = APIError.toAPIError(errorCode)
        print(error.description)
        
        switch error {
        case .expiredAccessToken:
            refreshToken()
                .subscribe(onSuccess: { result in
                    if case .success(let value) = result {
                        UserDefaultsManager.shared.accessToken = value.accessToken
                    }
                })
        case .expiredRefreshToken:
            DispatchQueue.main.async {
                self.refreshTokenExpired?()
            }
        default:
            break
        }
        return error
    }
}

extension NetworkService {
    func logIn(query: Router) -> Single<Result<LogInResponse, Error>> {
        return request(api: query)
    }
    func signUp(query: Router) -> Single<Result<Profile, Error>> {
        return request(api: query)
    }
    func post(query: Router) -> Single<Result<PostResponse, Error>> {
        return request(api: query)
    }
    private func refreshToken() -> Single<Result<AccesToken, Error>> {
        return request(api: .auth(.tokenRefresh))
    }
}
