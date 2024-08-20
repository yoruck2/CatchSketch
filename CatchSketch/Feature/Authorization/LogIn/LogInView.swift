//
//  SignInView.swift
//  CatchSketch
//
//  Created by dopamint on 8/18/24.
//

import UIKit
import SnapKit

final class LogInView: BaseView {
    
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요").then {
        $0.text = "yoruck2"
    }
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요").then {
        $0.text = ""
    }
    let signInButton = ConfirmButton(title: "로그인")
    let signUpButton = ConfirmButton(title: "회원가입").then {
        $0.backgroundColor = CatchSketch.Color.darkGreen
    }
    
    override func configureLayout() {
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(signInButton)
        addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
}

