//
//  SignUpView.swift
//  CatchSketch
//
//  Created by dopamint on 8/15/24.
//

import UIKit
import SnapKit
import Then

final class SignUpView: BaseView {
    private let titleLabel = UILabel().then {
        $0.text = "회원가입"
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    let emailTextField = SignTextField(placeholderText: "이메일")
    let passwordTextField = SignTextField(placeholderText: "비밀번호")
    let nicknameTextField = SignTextField(placeholderText: "닉네임")
    
    let signUpButton = ConfirmButton(title: "가입하기")

    override func configureLayout() {
        
        addSubview(titleLabel)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(nicknameTextField)
        addSubview(signUpButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(100)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(44)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(44)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(40)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(44)
        }
    }
}


