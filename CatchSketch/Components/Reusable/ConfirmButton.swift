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
            updateAppearance()
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        titleLabel?.font = CatchSketch.Font.bold20
        layer.cornerRadius = 15
        updateAppearance()
    }
    private func updateAppearance() {
        backgroundColor = isEnabled ? CatchSketch.Color.mainGreen : .gray
        setTitleColor(isEnabled ? .white : .lightGray, for: .normal)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
