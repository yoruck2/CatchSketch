//
//  BackButton.swift
//  CatchSketch
//
//  Created by dopamint on 10/28/24.
//

import UIKit
import SnapKit
import Then

final class CircleButton: UIButton {

    
    init(image: UIImage) {
        super.init(frame: .zero)
        configure(iamge: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure(iamge: UIImage) {
        backgroundColor = .white
        
        let chevronImage = iamge
        setImage(chevronImage, for: .normal)
        
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = UIEdgeInsets(top: 5, left: 3, bottom: 5, right: 5)
        
        layer.cornerRadius = 20
        clipsToBounds = false
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        
        snp.makeConstraints { make in
            make.size.equalTo(45)
        }
    }
}
