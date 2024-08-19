//
//  SignInViewModel.swift
//  CatchSketch
//
//  Created by dopamint on 8/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LogInViewModel: BaseViewModel {
    
    struct Input {
        let tap: ControlEvent<Void>
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
    }
    
    struct Output {
        let loginResult: Observable<Result<LogInResponse, Error>>
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
                NetworkService.shared.signIn(query: .auth(.login(query: query)), 
                                             model: LogInResponse.self)
                .catch { error in
                    return .just(.failure(error))
                }
            }
            .share(replay: 1)
        return Output(loginResult: result)
    }
}
