//
//  PostQuizView.swift
//  CatchSketch
//
//  Created by dopamint on 8/19/24.
//

import UIKit
import SnapKit
import Then

final class PostSketchView: BaseView {
    
    let quizImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
        $0.contentMode = .scaleToFill
    }
    
    let correctAnswerTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "정답을 입력하세요"
    }
    
    let randomAnswerButton = UIButton().then {
        $0.setTitle("랜덤", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
        $0.backgroundColor = .systemGray6
        $0.layer.cornerRadius = 5
    }
    
    let drawSketchButton = UIButton().then {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        let largeSymbolImage = UIImage(systemName: "pencil.circle.fill", withConfiguration: largeConfig)
        $0.setImage(largeSymbolImage, for: .normal)
        $0.tintColor = CatchSketch.Color.mainGreen
        $0.contentMode = .scaleAspectFit
        $0.layer.borderColor = CatchSketch.Color.darkGreen.cgColor
        $0.layer.borderWidth = 5
        $0.clipsToBounds = true
    }
    
    let sketchPostButton = ConfirmButton(title: "그림 올리기").then {
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        drawSketchButton.layer.cornerRadius = drawSketchButton.frame.size.width / 2
    }
    
    override func configureHierarchy() {
        [quizImageView, correctAnswerTextField, randomAnswerButton, drawSketchButton, sketchPostButton].forEach(addSubview)
    }
    
    override func configureLayout() {
        quizImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(quizImageView.snp.width).multipliedBy(1.3)
        }
        
        correctAnswerTextField.snp.makeConstraints { make in
            make.top.equalTo(quizImageView.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        randomAnswerButton.snp.makeConstraints { make in
            make.top.equalTo(correctAnswerTextField)
            make.left.equalTo(correctAnswerTextField.snp.right).offset(10)
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(60)
            make.height.equalTo(correctAnswerTextField)
        }
        
        drawSketchButton.snp.makeConstraints { make in
            make.bottom.right.equalTo(quizImageView).inset(10)
            make.size.equalTo(70)
        }
        
        sketchPostButton.snp.makeConstraints { make in
            make.top.equalTo(correctAnswerTextField.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
}
