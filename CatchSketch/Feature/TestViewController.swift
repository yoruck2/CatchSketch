//
//  TestViewController.swift
//  CatchSketch
//
//  Created by dopamint on 10/24/24.
//

import UIKit
import SnapKit
import Then

class TestViewController: UIViewController {
    
    let gridView = UIImageView().then {
        $0.image = .grid
    }
    let imageView = UIImageView().then {
        $0.image = .torn
    }
    let logoImageView = UIImageView().then {
        $0.image = .logo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        configureLayout()
    }
    func configureLayout() {
        view.addSubview(gridView)
        view.addSubview(imageView)
        view.addSubview(logoImageView)
        
        gridView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(400)
            make.height.equalTo(400)
            make.center.equalToSuperview()
        }
        logoImageView.snp.makeConstraints { make in
            make.width.equalTo(280)
            make.height.equalTo(200)
            make.center.equalToSuperview()
        }
    }
}
