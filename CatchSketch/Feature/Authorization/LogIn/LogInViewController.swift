//
//  SignInViewController.swift
//  CatchSketch
//
//  Created by dopamint on 8/18/24.
//

import UIKit
import RxSwift
import RxCocoa

final class LogInViewController: BaseViewController<LogInView> {
    let viewModel = LogInViewModel()
    let disposeBag = DisposeBag()
    
    override func bind() {
        let input = LogInViewModel.Input(tap: rootView.signInButton.rx.tap,
                                          emailText: rootView.emailTextField.rx.text.orEmpty,
                                          passwordText: rootView.passwordTextField.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        output.loginResult
            .bind(with: self) { owner, value in
                switch value {
                case .success(let value):
                    UserDefaultsManager.shared.accessToken = value.accessToken
                    UserDefaultsManager.shared.refreshToken = value.refreshToken
                    owner.changeRootViewController(MainFeedViewController())
                case .failure(let error):
                    print(error)
                }
            }.disposed(by: disposeBag)
        
        rootView.signUpButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?
                    .present(SignUpViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
}
