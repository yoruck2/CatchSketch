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
//                    owner.changeRootViewController(CatchSketchTabBarController())
//                    owner.present(CatchSketchTabBarController(), animated: true)
                    owner.navigationController?.pushViewController(CatchSketchTabBarController(), animated: true)
                case .failure(let error):
                    owner.showAlert(title: "로그인 실패", message: "계정을 확인해주세요. 🥲")
                    print(error)
                }
            }.disposed(by: disposeBag)
        
        output.isLoginValid
            .bind(with: self) { owner, value in
                owner.rootView.signInButton.isEnabled = value
            }.disposed(by: disposeBag)
        
        rootView.signUpButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.present(SignUpViewController(rootView: SignUpView()), animated: true)
            }
            .disposed(by: disposeBag)
    }
}
