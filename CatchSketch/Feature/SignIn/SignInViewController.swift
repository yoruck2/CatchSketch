//
//  SignInViewController.swift
//  CatchSketch
//
//  Created by dopamint on 8/18/24.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: BaseViewController<SignInView> {
    let disposeBag = DisposeBag()
    let viewModel = SignInViewModel()
    
//    let basicColor = Observable.just(UIColor.systemBlue)
    let loginQuery = AuthQuery.LogIn(email: "yoruck2", password: "1234")
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NetworkService.shared.requestC(api: .auth(.login(query: loginQuery)),
//                                       model: LogInResponse.self)
        
        //        let aa = NetworkService.shared.request(api: .auth(.login(query: loginQuery)),
        //                                      model: LogInResponse.self)
        //            .catch { error in
        ////                return Single.just(.failure(.responseValidationFailed(reason: .customValidationFailed(error: error))))
        //                return Single.never()
        //            }
        //        aa.subscribe(with: self) { owner , ss in
        //            switch ss {
        //            case .success(let value):
        //                dump(value)
        //            case .failure(let error):
        //                print(error.responseCode)
        //            }
        //        }.disposed(by: disposeBag)
    }
    
    override func bind() {
        
        let input = SignInViewModel.Input(tap: rootView.signInButton.rx.tap,
                                          emailText: rootView.emailTextField.rx.text.orEmpty,
                                          passwordText: rootView.passwordTextField.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        output.loginResult
            .bind(with: self) { _, value in
                switch value {
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error)
                }
            }.disposed(by: disposeBag)
        
        rootView.signUpButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?
                    .pushViewController(SignUpViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
}
