//
//  MainFeedCollectionViewCell.swift
//  CatchSketch
//
//  Created by dopamint on 8/19/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class MainFeedCollectionViewCell: BaseCollectionViewCell {
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let gradientLayer = CAGradientLayer()
    
    private let creatorImageView = UIImageView().then {
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    private let creatorNameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .white
    }
    
    private let uploadDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .lightGray
    }
    
    private let heartSymbol = UIImageView().then {
        $0.image = UIImage(systemName: "heart.fill")
        $0.tintColor = .white
    }
    
    private let favoriteCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
    }
    
    private let bubbleSymbol = UIImageView().then {
        $0.image = UIImage(systemName: "bubble.right.fill")
        $0.tintColor = .white
    }
    
    private let answerCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
    }
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.layer.addSublayer(gradientLayer)
        contentView.addSubview(creatorImageView)
        contentView.addSubview(creatorNameLabel)
        contentView.addSubview(uploadDateLabel)
        contentView.addSubview(heartSymbol)
        contentView.addSubview(favoriteCountLabel)
        contentView.addSubview(bubbleSymbol)
        contentView.addSubview(answerCountLabel)
    }
    
    override func configureLayout() {

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        creatorImageView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(15)
            make.size.equalTo(40)
        }
        
        creatorNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(creatorImageView.snp.trailing).offset(10)
            make.bottom.equalTo(creatorImageView.snp.centerY)
        }
        
        uploadDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(creatorNameLabel)
            make.top.equalTo(creatorNameLabel.snp.bottom).offset(2)
        }
        
        answerCountLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(15)
        }
        
        bubbleSymbol.snp.makeConstraints { make in
            make.trailing.equalTo(answerCountLabel.snp.leading).offset(-5)
            make.centerY.equalTo(answerCountLabel)
            make.size.equalTo(20)
        }
        
        favoriteCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(bubbleSymbol.snp.leading).offset(-10)
            make.centerY.equalTo(bubbleSymbol)
        }
        
        heartSymbol.snp.makeConstraints { make in
            make.trailing.equalTo(favoriteCountLabel.snp.leading).offset(-5)
            make.centerY.equalTo(favoriteCountLabel)
            make.size.equalTo(20)
        }
        
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        setupGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    func configure(with post: Post) {
        creatorNameLabel.text = post.creator?.nick
        uploadDateLabel.text = post.createdAt
        favoriteCountLabel.text = "\(post.likes?.count ?? 0)"
        answerCountLabel.text = "\(post.comments?.count ?? 0)"
        
        let url = post.files?.first ?? ""
        let url2 = post.creator?.profileImage
        
        var modifier = AnyModifier { request in
            var request = request
            request.setValue(APIAuth.catchSketchAPI.key, forHTTPHeaderField: Header.sesacKey.rawValue)
            request.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: Header.authorization.rawValue)
            
            return request
        }
        
        let aaa = URL(string: APIAuth.catchSketchAPI.baseURL + "/v1/" + url)
        imageView.kf.setImage(with: aaa, options: [.requestModifier(modifier)])
//        creatorImageView.image = post.creatorImage
    }
    
    private func setupGradient() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        gradientLayer.locations = [0.5, 1.0]
        gradientLayer.frame = bounds
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


