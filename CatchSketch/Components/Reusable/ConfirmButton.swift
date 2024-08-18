//
//  ConfirmButton.swift
//  CatchSketch
//
//  Created by dopamint on 8/18/24.
//

import Foundation

import UIKit

final class ConfirmButton: UIButton {
    
    override var isEnabled: Bool {
        
        // MARK: observable 내부적으로 결국 didSet으로 바인딩을 하고있긴 하다 -
        didSet {
            backgroundColor = isEnabled ? .blue : .gray
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .blue
        layer.cornerRadius = 10
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
