//
//  SketchQuizView.swift
//  CatchSketch
//
//  Created by dopamint on 8/28/24.
//

import UIKit
import SnapKit
import Then

class SketchQuizView: BaseView {
    
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
    let sketchImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    let tapeImageView = UIImageView().then {
        $0.image = .tape
        $0.contentMode = .scaleAspectFit
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
         tapeImageView,
         commentCollectionView,
         dividerPaper,
         catchButton].forEach(addSubview)
        stickedPaperImageView.addSubview(sketchImageView)
    }
    
    override func configureLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stickedPaperImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.42)
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
