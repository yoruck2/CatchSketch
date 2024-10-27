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
    
    let dispoesBag = DisposeBag()
    var refreshTokenExpired: (() -> Void)?
    
    func request<T: Decodable>(api: Router) -> Single<Result<T, Error>> {
        return Single.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            self.request(api: api, observer: observer)
            return Disposables.create()
        }
    }
    
    private func request<T: Decodable>(api: Router,
                                       observer: @escaping (SingleEvent<Result<T, Error>>) -> Void) {
        let request: DataRequest
        
        switch api {
        case .post(.uploadImage(let files)):
            let url = APIAuth.catchSketchAPI.baseURL + "/v1/posts/files"
            let headers: HTTPHeaders = [
                Header.sesacKey.rawValue: APIAuth.catchSketchAPI.key,
                Header.contentType.rawValue: Header.multiPart.rawValue,
                Header.authorization.rawValue: UserDefaultsManager.shared.accessToken
            ]
            request = AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(files, withName: "files", fileName: "image.jpg", mimeType: "image/jpeg")
            }, to: url, method: .post, headers: headers)
            
        default:
            request = AF.request(api)
        }
        
        request.validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { [weak self] response in
                self?.handleResponse(response, api: api, observer: observer)
                
                print("✨✨✨Response: \(String(describing: response.response?.statusCode))")
            }
    }
    
    private func handleResponse<T: Decodable>(_ response: DataResponse<T, AFError>, 
                                              api: Router,
                                              observer: @escaping (SingleEvent<Result<T, Error>>) -> Void) {
//        dump("Request: \(String(describing: response.request))")
        print("Request: \(String(describing: response.request?.headers))")
        print("Response: \(String(describing: response.response))")
        print("Result: \(String(describing: response.result))")
        
        switch response.result {
        case .success(let value):
            print("✅✅✅✅✅  succeeded")
            observer(.success(.success(value)))
        case .failure(let error):
            print("❌❌❌❌❌ failed: \(error)")
            
            if let errorCode = error.responseCode {
                self.handleError(errorCode: errorCode, api: api, observer: observer)
            } else {
                observer(.success(.failure(error)))
            }
        }
    }
    
    private func handleError<T: Decodable>(errorCode: Int, api: Router, observer: @escaping (SingleEvent<Result<T, Error>>) -> Void) {
        let error = APIError.toAPIError(errorCode)
        print("\(error.description)")
        
        switch error {
        case .expiredAccessToken:
            refreshToken()
                .subscribe(onSuccess: { [weak self] result in
                    guard let self = self else { return }
                    if case .success(let value) = result {
                        print("😡😡😡😡 Token refreshed")
                        UserDefaultsManager.shared.accessToken = value.accessToken
                        self.request(api: api, observer: observer)
                    } else {
                        observer(.success(.failure(error)))
                    }
                }, onFailure: { refreshError in
                    observer(.success(.failure(refreshError)))
                })
                .disposed(by: dispoesBag)
        case .expiredRefreshToken:
            DispatchQueue.main.async {
                self.refreshTokenExpired?()
            }
        default:
            observer(.success(.failure(error)))
        }
    }
    
    private func refreshToken() -> Single<Result<AccesToken, Error>> {
        return Single.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            let request = AF.request(Router.auth(.tokenRefresh))
            request.validate(statusCode: 200..<300)
                .responseDecodable(of: AccesToken.self) { response in
                    self.handleResponse(response, api: .auth(.tokenRefresh), observer: observer)
                }
            
            return Disposables.create()
        }
    }
}
extension NetworkService {
    func logIn(query: Router) -> Single<Result<LogInResponse, Error>> {
        return request(api: query)
    }
    func signUp(query: Router) -> Single<Result<Profile, Error>> {
        return request(api: query)
    }
    func fetchMyProfile(query: Router) -> Single<Result<ProfileResponse, Error>> {
        return request(api: query)
    }
    
    // 포스트 전체조회, 특정포스트 조회
    func viewPost(query: Router) -> Single<Result<PostResponse, Error>> {
        return request(api: query)
    }
    func getSpecificPost(query: Router) -> Single<Result<PostResponse.Post, Error>> {
        return request(api: query)
    }
    
    // 게시글 올리기
    func post(query: Router) -> Single<Result<PostResponse.Post, Error>> {
        return request(api: query)
            .map { (result: Result<PostResponse.Post, Error>) -> Result<PostResponse.Post, Error> in
                switch result {
                case .success(let postResponse):
                    return .success(postResponse)
                    
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    // 이미지 올리기
    func postImage(query: Router) -> Single<Result<ImageUploadResponse, Error>> {
        return request(api: query)
    }
    // 댓글 달기
    func postComment(query: Router) -> Single<Result<PostResponse.Comment, Error>> {
        return request(api: query)
    }
    
}

