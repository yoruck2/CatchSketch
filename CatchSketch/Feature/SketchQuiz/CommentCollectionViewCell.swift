//
//  CommentCollectionViewCell.swift
//  CatchSketch
//
//  Created by dopamint on 8/28/24.
//

import UIKit
import SnapKit

enum CommentType {
    case creator
    case commenter
}

class BubbleView: UIView {
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)), cornerRadius: 8)
        let trianglePath = UIBezierPath()
        
        if self.tag == 0 { // Creator
            trianglePath.move(to: CGPoint(x: 0, y: rect.height / 2 - 10))
            trianglePath.addLine(to: CGPoint(x: 0, y: rect.height / 2 + 10))
            trianglePath.addLine(to: CGPoint(x: 10, y: rect.height / 2))
        } else { // Commenter
            trianglePath.move(to: CGPoint(x: rect.width, y: rect.height / 2 - 10))
            trianglePath.addLine(to: CGPoint(x: rect.width, y: rect.height / 2 + 10))
            trianglePath.addLine(to: CGPoint(x: rect.width - 10, y: rect.height / 2))
        }
        path.append(trianglePath)
        UIColor.systemGray6.setFill()
        path.fill()
    }
}

class CommentCollectionViewCell: BaseCollectionViewCell {
    let profileImageView = UIImageView()
    let commentView = BubbleView()
    let nicknameLabel = UILabel()
    let commentLabel = UILabel()
    
    var commentType: CommentType = .commenter {
        didSet {
            setupLayout()
        }
    }
    
    override func configureLayout() {
        
        [profileImageView, commentView, nicknameLabel, commentLabel].forEach { contentView.addSubview($0) }
        
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20 // Assuming a size of 40x40
        
        commentView.backgroundColor = .clear
        
        nicknameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        commentLabel.font = .systemFont(ofSize: 14)
        commentLabel.numberOfLines = 0
        
        setupLayout()
    }
    
    private func setupLayout() {
        switch commentType {
        case .creator:
            configureCreatorLayout()
        case .commenter:
            configureCommenterLayout()
        }
    }
    
    private func configureCreatorLayout() {
        commentView.tag = 0
        
        profileImageView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        nicknameLabel.snp.remakeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(18)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        commentView.snp.remakeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            make.leading.equalTo(nicknameLabel)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        commentLabel.snp.remakeConstraints { make in
            make.edges.equalTo(commentView).inset(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 22))
            make.width.lessThanOrEqualTo(contentView).multipliedBy(0.7) // Limit width to 70% of contentView
        }
    }
    
    private func configureCommenterLayout() {
        commentView.tag = 1
        
        profileImageView.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        commentView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalTo(profileImageView.snp.leading).offset(-18)
            make.leading.greaterThanOrEqualToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        nicknameLabel.snp.remakeConstraints { make in
            make.top.leading.equalTo(commentView).offset(8)
            make.trailing.lessThanOrEqualTo(commentView).offset(-8)
        }
        
        commentLabel.snp.remakeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            make.leading.equalTo(commentView).offset(12)
            make.trailing.equalTo(commentView).offset(-22)
            make.bottom.equalTo(commentView).offset(-8)
            make.width.lessThanOrEqualTo(contentView).multipliedBy(0.7)
        }
    }
    
    func configure(with type: CommentType, nickname: String, comment: String) {
        commentType = type
        nicknameLabel.text = nickname
        commentLabel.text = comment
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commentView.setNeedsDisplay()
    }
}
