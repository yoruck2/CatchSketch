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
                    switch error.asAFError?.responseCode {
                    case 409:
                        owner.showAlert(title: "중복 닉네임",
                                        message: "다른분이 사용중인 이메일 또는 닉네임 입니다.\n다른 닉네임을 입력해주세요!")
                    default: 
                        print(error.asAFError?.responseCode)
                        return
                    }
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
