//
//  SketchQuizView.swift
//  CatchSketch
//
//  Created by dopamint on 8/28/24.
//

import UIKit
import SnapKit
import Then

final class SketchQuizView: BaseView {
    
    private let backgroundImageView = UIImageView().then {
        $0.image = UIImage(resource: .paper1)
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let stickedPaperImageView = UIImageView().then {
        $0.image = .stickpaper
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .clear
    }
    let backButton = CircleButton(image: .back)
    let deleteButton = CircleButton(image: .delete)
    let sketchImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    let tapeImageView = UIImageView().then {
        $0.image = .tape
        $0.contentMode = .scaleAspectFit
    }
    
    // 힌트 버튼들을 담을 컨테이너 뷰
    let hintButtonsContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    // 초성 보기 버튼 관련 뷰들
    let chosungButton = UIButton().then {
        $0.backgroundColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1.0)
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    let chosungTopLabel = UILabel().then {
        $0.text = "초성 보기"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    let chosungBottomStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }
    
    let chosungCircleImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .yellow
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        $0.image = UIImage(systemName: "circle.fill", withConfiguration: config)
    }
    
    let chosungCountLabel = UILabel().then {
        $0.text = "5"
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .black
    }
    
    // 글자 수 보기 버튼 관련 뷰들
    let letterCountButton = UIButton().then {
        $0.backgroundColor = UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0)
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    let letterCountTopLabel = UILabel().then {
        $0.text = "글자 수 보기"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    let letterCountBottomStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }
    
    let letterCountCircleImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .yellow
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        $0.image = UIImage(systemName: "circle.fill", withConfiguration: config)
    }
    
    let letterCountNumberLabel = UILabel().then {
        $0.text = "2"
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .black
    }
    
    let dividerPaper = UIImageView().then {
        $0.image = .dividerPaper
        $0.contentMode = .scaleAspectFill
    }
    let commentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.commentCollectionViewLayout).then {
        $0.backgroundColor = .white
    }
    let catchButton = UIButton(configuration: .filled()).then {
        var attString = AttributedString("정답 제시!")
        attString.font = .systemFont(ofSize: 20, weight: .bold)
        $0.configuration?.baseBackgroundColor = CatchSketch.Color.mainGreen
        $0.configuration?.cornerStyle = .medium
        $0.configuration?.attributedTitle = attString
    }
    
    override func configureHierarchy() {
        [backgroundImageView,
         stickedPaperImageView,
         backButton,
         deleteButton,
         tapeImageView,
         commentCollectionView,
         dividerPaper,
         hintButtonsContainer,
         catchButton].forEach(addSubview)
        stickedPaperImageView.addSubview(sketchImageView)
        
        [chosungTopLabel, chosungBottomStack].forEach { view in
            chosungButton.addSubview(view)
        }
        [chosungCircleImage, chosungCountLabel].forEach { view in
            chosungBottomStack.addArrangedSubview(view)
        }
        
        [letterCountTopLabel, letterCountBottomStack].forEach { view in
            letterCountButton.addSubview(view)
        }
        [letterCountCircleImage, letterCountNumberLabel].forEach { view in
            letterCountBottomStack.addArrangedSubview(view)
        }
        
        // 힌트 버튼들을 컨테이너에 추가
        [chosungButton, letterCountButton].forEach(hintButtonsContainer.addArrangedSubview)
    }
    
    override func configureLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stickedPaperImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.43)
        }
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(-7)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
        }
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(-7)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        sketchImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        tapeImageView.snp.makeConstraints { make in
            make.top.equalTo(sketchImageView).offset(-35)
            make.centerX.equalTo(sketchImageView).offset(-5)
            make.width.equalTo(90)
            make.height.equalTo(45)
        }
        
        hintButtonsContainer.snp.makeConstraints { make in
            make.bottom.equalTo(stickedPaperImageView).offset(-7)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(53)
        }
        
        chosungTopLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        
        chosungBottomStack.snp.makeConstraints { make in
            make.top.equalTo(chosungTopLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        chosungCircleImage.snp.makeConstraints { make in
            make.size.equalTo(12)
        }
        
        // 글자 수 버튼 내부 레이아웃
        letterCountTopLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        
        letterCountBottomStack.snp.makeConstraints { make in
            make.top.equalTo(letterCountTopLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        letterCountCircleImage.snp.makeConstraints { make in
            make.size.equalTo(12)
        }
        
        commentCollectionView.snp.makeConstraints { make in
            make.top.equalTo(stickedPaperImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
        dividerPaper.snp.makeConstraints { make in
            make.top.equalTo(commentCollectionView).offset(-12)
            make.horizontalEdges.equalToSuperview().inset(-20)
            make.height.equalTo(5)
        }
        catchButton.snp.makeConstraints { make in
            make.bottom.equalTo(commentCollectionView.snp.bottom).inset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(50)
        }
    }
}
