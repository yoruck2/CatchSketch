//
//  SignUpViewModel.swift
//  CatchSketch
//
//  Created by dopamint on 8/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: BaseViewModel {
    
    struct Input {
        let tap: ControlEvent<Void>
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
        let nicknameText: ControlProperty<String>
    }
    struct Output {
        let signUpResult: Observable<Result<Profile, Error>>
        let isSignUpVaild: Observable<Bool>
        //        let isValidEmail: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let signUpQuery = Observable.combineLatest(input.emailText, input.passwordText, input.nicknameText)
            .map { AuthQuery.SignUp(email: $0, password: $1, nick: $2) }
            .share(replay: 1)
        
        let result = input.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(signUpQuery)
            .flatMapLatest { query in
                NetworkService.shared.signUp(query: .auth(.SignUp(query: query)))
                    .catch { error in
                        print("SignUp 오류: \(error.localizedDescription)")
                        return .just(.failure(error))
                    }
            }
            .share(replay: 1)
        
        //        let isEmailValid = input.emailText
        //            .map(matchesEmailPattern)
        
        let isSignUpVaild = Observable.combineLatest(input.emailText,
                                                     input.passwordText,
                                                     input.nicknameText)
            .map { !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty }
        
        return Output(signUpResult: result, 
                      isSignUpVaild: isSignUpVaild
                      /*isValidEmail: isEmailValid*/)
    }
    
    private func matchesEmailPattern(_ string: String) -> Bool {
        do {
            let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let regex = try NSRegularExpression(pattern: emailPattern)
            let range = NSRange(location: 0, length: string.utf16.count)
            return regex.firstMatch(in: string, options: [], range: range) != nil
        } catch {
            print(error)
            return false
        }
    }
}

