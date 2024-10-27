//
//  UserInfoView.swift
//  CatchSketch
//
//  Created by dopamint on 10/28/24.
//

import UIKit
import SnapKit
import Then

final class UserInfoView: UIView {
    
    private let containerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    private let progressContainer = UIView().then {
        $0.backgroundColor = .systemGreen.withAlphaComponent(0.2)
        $0.layer.cornerRadius = 12
    }
    
    private let progressBar = UIProgressView().then {
        $0.progressTintColor = .mainGreen
        $0.trackTintColor = .clear
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.progress = 0
    }
    
    private let levelLabel = UILabel().then {
        $0.text = "LV. 0"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14, weight: .bold)
    }
    
    private let coinStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
    }
    
    private let plusButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.tintColor = .black
    }
    
    private let coinContainer = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }
    
    private let coinImageView = UIImageView().then {
        $0.image = UIImage(resource: .coin)
        $0.tintColor = .systemYellow
    }
    
    private let coinLabel = UILabel().then {
        $0.text = "0"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpData(data: ProfileResponse) {
        guard let exp = data.exp else { return }
        levelLabel.text = "LV. \(exp.calculateLevel().0)"
        progressBar.progress = exp.calculateLevel().1
        coinLabel.text = data.coin
        print("✏️✏️✏️✏️✏️")
        print(exp)
        print(exp.calculateLevel().0)
        print(exp.calculateLevel().1)
    }
    
    // MARK: - Configuration
    private func configureHierarchy() {
        addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(coinStackView)
        
        coinStackView.addSubview(plusButton)
        coinStackView.addSubview(coinContainer)
        coinContainer.addArrangedSubview(coinImageView)
        coinContainer.addArrangedSubview(coinLabel)
        
        containerStackView.addArrangedSubview(progressContainer)
        progressContainer.addSubview(progressBar)
        progressContainer.addSubview(levelLabel)
    }
    
    private func configureLayout() {
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(36)
        }
        
        progressContainer.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.width.equalTo(80)
        }
        
        progressBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        levelLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        coinStackView.snp.makeConstraints { make in
            make.height.equalTo(28)
        }
        plusButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
        }
        
        coinContainer.snp.makeConstraints { make in
            make.leading.equalTo(plusButton.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        coinImageView.snp.makeConstraints { make in
            make.size.equalTo(23)
        }
    }
}
