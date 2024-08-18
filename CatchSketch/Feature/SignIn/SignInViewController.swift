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
    let viewModel = SignInViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
