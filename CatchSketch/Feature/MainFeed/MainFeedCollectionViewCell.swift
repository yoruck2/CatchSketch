//
//  MainFeedCollectionViewCell.swift
//  CatchSketch
//
//  Created by dopamint on 8/19/24.
//

import UIKit
import Then

final class MainFeedCollectionViewCell: BaseCollectionViewCell {
    private let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 18)
        $0.textColor = .white
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    func configureUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
    }
    
    func configure(with title: String) {
        titleLabel.text = title
        contentView.backgroundColor = .random()
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}


