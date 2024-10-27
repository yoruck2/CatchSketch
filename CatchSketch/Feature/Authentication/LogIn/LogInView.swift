//
//  SignInView.swift
//  CatchSketch
//
//  Created by dopamint on 8/18/24.
//

import UIKit
import SnapKit

final class LogInView: BaseView {
    
    let gridView = UIImageView().then {
        $0.image = .paper1
    }
    let imageView = UIImageView().then {
        $0.image = .torn
    }
    let logoImageView = UIImageView().then {
        $0.image = .logo
    }
    
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요").then {
//        $0.text = "yoruck2"
        $0.text = "야옹"
        $0.backgroundColor = .white
    }
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요").then {
        $0.text = "1234"
        $0.backgroundColor = .white
    }
    let signInButton = ConfirmButton(title: "로그인")
    let signUpButton = ConfirmButton(title: "회원가입").then {
        $0.backgroundColor = CatchSketch.Color.darkGreen
    }
    
    override func configureLayout() {
        addSubview(gridView)
        addSubview(imageView)
        imageView.addSubview(logoImageView)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(signInButton)
        addSubview(signUpButton)
        
        gridView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.center.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview().offset(-10)
            make.width.equalTo(400)
            make.height.equalTo(380)
        }
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(300)
        }
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(logoImageView.snp.bottom).offset(80)
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

