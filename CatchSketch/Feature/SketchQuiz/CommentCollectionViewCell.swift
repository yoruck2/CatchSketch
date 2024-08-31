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
        commentType = .commenter
        resetLayout()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(commentView)
        commentView.addSubview(nicknameLabel)
        commentView.addSubview(commentLabel)

        commentView.backgroundColor = .clear
        resetLayout()
    }
    
    private func resetLayout() {
        profileImageView.snp.removeConstraints()
        commentView.snp.removeConstraints()
        nicknameLabel.snp.removeConstraints()
        commentLabel.snp.removeConstraints()
        setupLayout()
    }
    
    private func setupLayout() {
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
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(18)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(12)
            make.trailing.lessThanOrEqualToSuperview().offset(-22)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(12)
            make.trailing.lessThanOrEqualToSuperview().offset(-22)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    private func configureCommenterLayout() {
        commentView.tag = 1
        
        profileImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(5)
            make.top.equalToSuperview().inset(10)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        commentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalTo(profileImageView.snp.leading).offset(-8)
            make.leading.greaterThanOrEqualToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-22)
            make.leading.greaterThanOrEqualToSuperview().offset(12)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            make.leading.greaterThanOrEqualToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-22)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        nicknameLabel.textAlignment = .right
    }
    
    func setUpCellData(with type: CommentType, data: Comment) {
        commentType = type
        resetLayout()
        
        let url = data.creator?.profileImage ?? ""
        
        profileImageView.setImageWithToken(urlString: url, placeholder: UIImage(systemName: "person.crop.circle"))
        nicknameLabel.text = data.creator?.nick
        commentLabel.text = data.content
        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commentView.setNeedsDisplay()
    }
}


class BubbleView: UIView {
    override func draw(_ rect: CGRect) {
        var path = UIBezierPath(roundedRect: rect.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)), cornerRadius: 8)
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
        UIColor.systemGray6.setFill()
        path.fill()
    }
}
