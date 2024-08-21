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
                    print("Result: \(String(describing: response.response?.statusCode))")
                    switch response.result {
                    case .success(let value):
                        print("✅✅✅✅✅✅✅")
                        observer(.success(.success(value)))
                    case .failure(let error):
                        print("왜안되나영")
                        guard let errorCode = error.responseCode else {
                            print("✨ 여기 오면 안돼")
                            return
                        }
                        //                        print(errorCode)
                        let apiError = self.handleError(errorCode: errorCode)
                        observer(.success(.failure(apiError)))
                    }
                }
            return Disposables.create()
        }.debug("request")
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
    func post(query: Router) -> Single<Result<PostResponse, Error>> {
        return request(api: query)
    }
    private func refreshToken() -> Single<Result<AccesToken, Error>> {
        return request(api: .auth(.tokenRefresh))
    }
}
