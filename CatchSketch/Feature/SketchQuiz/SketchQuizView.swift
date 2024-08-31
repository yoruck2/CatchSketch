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
    let sketchImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .lightGray
    }
    let commentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.commentCollectionViewLayout).then {
        $0.backgroundColor = .clear
    }
    let catchButton = UIButton(configuration: .filled()).then {
        var attString = AttributedString("정답 제시!")
        attString.font = .systemFont(ofSize: 20, weight: .bold)
        $0.configuration?.baseBackgroundColor = CatchSketch.Color.mainGreen
        $0.configuration?.cornerStyle = .medium
        $0.configuration?.attributedTitle = attString
    }
    override func configureHierarchy() {
        [sketchImageView, commentCollectionView, catchButton].forEach(addSubview)
    }
    
    override func configureLayout() {
        sketchImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        commentCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sketchImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
        catchButton.snp.makeConstraints { make in
            make.bottom.equalTo(commentCollectionView.snp.bottom).inset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(50)
        }
    }
}
