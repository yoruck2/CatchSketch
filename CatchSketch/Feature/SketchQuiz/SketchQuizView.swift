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
    let commentCollectionView = UICollectionView().then {
        $0.backgroundColor = .systemGreen
        $0.layer.cornerRadius = 20
    }
    let catchButton = UIButton()

    override func configureHierarchy() {
        [sketchImageView, commentCollectionView, catchButton].forEach(addSubview)
    }

    override func configureLayout() {
        sketchImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }

        commentCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sketchImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(catchButton.snp.top).offset(-20)
        }

        catchButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
}
