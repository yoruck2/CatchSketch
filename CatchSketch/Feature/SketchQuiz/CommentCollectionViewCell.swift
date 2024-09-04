//
//  CommentCollectionViewCell.swift
//  CatchSketch
//
//  Created by dopamint on 8/28/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

enum CommentType: CaseIterable {
    case creator
    case commenter
    case me
    case correctAnswer
}

class CommentCollectionViewCell: BaseCollectionViewCell {
    let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
    }
    let commentView = BubbleView()
    let nicknameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .heavy)
    }
    let commentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    var commentType: CommentType = .commenter
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nicknameLabel.text = nil
        commentLabel.text = nil
    }
    
    override func configureHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(commentView)
        commentView.addSubview(nicknameLabel)
        commentView.addSubview(commentLabel)
        commentView.backgroundColor = .clear
    }
    
    private func setupLayout() {
        [profileImageView, commentView, nicknameLabel, commentLabel].forEach { $0.snp.removeConstraints() }
        
        commentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        switch commentType {
        case .creator:
            configureCreatorLayout()
        default:
            configureCommenterLayout()
        }
    }
    
    private func configureCreatorLayout() {
        commentView.tag = 0
        profileImageView.isHidden = true
        
        commentView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            make.leading.equalTo(nicknameLabel)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        nicknameLabel.textAlignment = .left
        commentLabel.textAlignment = .left
    }
    
    private func configureCommenterLayout() {
        commentView.tag = 1
        profileImageView.isHidden = false
        
        profileImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(5)
            make.top.equalToSuperview().inset(10)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        commentView.snp.makeConstraints { make in
            make.trailing.equalTo(profileImageView.snp.leading).offset(-8)
            make.leading.greaterThanOrEqualToSuperview().offset(16)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            make.trailing.equalTo(nicknameLabel)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.greaterThanOrEqualToSuperview().offset(16)
        }
        
        nicknameLabel.textAlignment = .right
        commentLabel.textAlignment = .right
    }
    
    func setUpCellData(with type: CommentType, data: PostResponse.Comment) {
        commentType = type
        
        let url = data.creator?.profileImage ?? ""
        profileImageView.setImageWithToken(urlString: url, placeholder: UIImage(systemName: "person.crop.circle"))
        nicknameLabel.text = data.creator?.nick
        commentLabel.text = data.content
        
        setupLayout()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commentView.setNeedsDisplay()
    }
}

class BubbleView: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
    
    override func draw(_ rect: CGRect) {
        let path: UIBezierPath
        let trianglePath = UIBezierPath()
        
        if self.tag == 0 {
            // 왼쪽에 삼각형
            path = UIBezierPath(roundedRect: rect.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)), cornerRadius: 8)
            trianglePath.move(to: CGPoint(x: 10, y: 20))
            trianglePath.addLine(to: CGPoint(x: 0, y: 30))
            trianglePath.addLine(to: CGPoint(x: 10, y: 40))
        } else {
            // 오른쪽에 삼각형
            path = UIBezierPath(roundedRect: rect.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)), cornerRadius: 8)
            trianglePath.move(to: CGPoint(x: rect.width - 10, y: 20))
            trianglePath.addLine(to: CGPoint(x: rect.width, y: 30))
            trianglePath.addLine(to: CGPoint(x: rect.width - 10, y: 40))
        }
        path.append(trianglePath)
        CatchSketch.Color.skyBlue.setFill()
        path.fill()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
}
