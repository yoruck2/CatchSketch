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
    
    private let emailTextField = UITextField().then {
        $0.placeholder = "이메일"
        $0.borderStyle = .roundedRect
    }
    
    // 이메일 유효성 검사 필요
    
    private let passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호"
        $0.borderStyle = .roundedRect
        $0.isSecureTextEntry = true
    }
    
    let signUpButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.backgroundColor = .systemBlue
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
    }

    override func configureLayout() {
    
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(signUpButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(44)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(44)
        }
    }
}


