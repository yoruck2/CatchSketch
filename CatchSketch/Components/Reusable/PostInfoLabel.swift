//
//  PostInfoLabel.swift
//  CatchSketch
//
//  Created by dopamint on 8/27/24.
//

import UIKit

class PostInfoLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        textAlignment = .left
        font = .boldSystemFont(ofSize: 18)
        textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
