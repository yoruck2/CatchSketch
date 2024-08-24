//
//  SignInViewModel.swift
//  CatchSketch
//
//  Created by dopamint on 8/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LogInViewModel {
    
    struct Input {
        let tap: ControlEvent<Void>
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
    }
    
    struct Output {
        let loginResult: Observable<Result<LogInResponse, Error>>
        let isLoginValid: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        // 로그인
        let loginQuery = Observable.combineLatest(input.emailText, input.passwordText)
            .map { AuthQuery.LogIn(email: $0, password: $1) }
            .share(replay: 1)
        
        let result = input.tap
            .throttle(.seconds(1),latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(loginQuery)
            .flatMapLatest { query in
                NetworkService.shared.logIn(query: .auth(.login(query: query)))
                .catch { error in
//                    if (error as! APIError) == .expiredRefreshToken {
//                        return .just(.failure(error as! APIError))
//                    }
                    return .just(.failure(error))
                }
            }
            .share(replay: 1)
        
        let isLoginValid = Observable.combineLatest(input.emailText, 
                                                    input.passwordText)
            .map { !$0.0.isEmpty && !$0.1.isEmpty }
        
        return Output(loginResult: result, 
                      isLoginValid: isLoginValid)
    }
}
