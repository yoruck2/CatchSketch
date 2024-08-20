//
//  SignTextField.swift
//  CatchSketch
//
//  Created by dopamint on 8/18/24.
//

import UIKit

final class SignTextField: UITextField {
    
    init(placeholderText: String) {
        super.init(frame: .zero)
        
        textColor = .black
        placeholder = placeholderText
        textAlignment = .center
        borderStyle = .none
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "gray")?.cgColor
        autocapitalizationType = .none
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
