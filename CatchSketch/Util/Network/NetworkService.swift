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
    
    func request<T: Decodable>(api: Router) -> Single<Result<T, Error>> {
            return Single.create { observer in
                let request: DataRequest
                
                if let multipartFormData = api.multipartFormData() {
                    print("♻️ Preparing multipart form data")
                    request = AF.upload(multipartFormData: multipartFormData, with: api)
                } else {
                    request = AF.request(api)
                }
                
                request.validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        self.handleResponse(response, observer: observer)
                    }
                
                return Disposables.create {
                    request.cancel()
                }
            }
        }
        
        private func handleResponse<T: Decodable>(_ response: DataResponse<T, AFError>, observer: (SingleEvent<Result<T, Error>>) -> Void) {
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Result: \(String(describing: response.result))")
            
            switch response.result {
            case .success(let value):
                print("✅ Request succeeded")
                observer(.success(.success(value)))
            case .failure(let error):
                print("❌ Request failed: \(error)")
                if let data = response.data, let str = String(data: data, encoding: .utf8) {
                    print("Error Response Data: \(str)")
                }
                if let errorCode = error.responseCode {
                    let apiError = self.handleError(errorCode: errorCode)
                    observer(.success(.failure(apiError)))
                } else {
                    observer(.success(.failure(error)))
                }
            }
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
                    .disposed(by: DisposeBag())
            case .expiredRefreshToken:
                DispatchQueue.main.async {
                    self.refreshTokenExpired?()
                }
            default:
                break
            }
            return error
        }
        
        private func refreshToken() -> Single<Result<AccesToken, Error>> {
            return request(api: .auth(.tokenRefresh))
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
    }

