//
//  SignUpViewController.swift
//  CatchSketch
//
//  Created by dopamint on 8/18/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: BaseViewController<SignUpView> {
    let disposeBag = DisposeBag()
    let viewModel = SignUpViewModel()
    
    override func bind() {
        let input = SignUpViewModel.Input(tap: rootView.signUpButton.rx.tap,
                                          emailText: rootView.emailTextField.rx.text.orEmpty,
                                          passwordText: rootView.passwordTextField.rx.text.orEmpty,
                                          nicknameText: rootView.nicknameTextField.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        output.signUpResult
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, result in
                switch result {
                case .success(let response):
                    print("✅ 회원가입 성공: \(response)")
                    let action = UIAlertAction(title: "로그인하러 가기",
                                               style: .default) { [weak self] _ in
                        self?.dismiss(animated: true)
                    }
                    owner.showAlert(title: "회원가입 완료",
                                    message: "회원가입이 성공적으로 완료되었습니다!😆",
                                    actions: [action])
                case .failure(let error):
                    print("🔥 회원가입 실패: \(error.localizedDescription)")
                }
            }
            .disposed(by: disposeBag)
        
        output.isSignUpVaild
            .bind(with: self) { owner, value in
                owner.rootView.signUpButton.isEnabled = value
            }.disposed(by: disposeBag
            )
        // TODO: 임시 주석
//        output.isValidEmail
//            .bind(with: self) { owner, value in
//                owner.rootView.signUpButton.isEnabled = value
//            }
//            .disposed(by: disposeBag)
    }
}
