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

enum CommentType {
    case creator
    case commenter
    case me
    case correctAnswer
}

class BubbleView: UIView {
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)), cornerRadius: 8)
        let trianglePath = UIBezierPath()

        if self.tag == 0 {
            trianglePath.move(to: CGPoint(x: 10, y: rect.height / 2 - 10))
            trianglePath.addLine(to: CGPoint(x: 10, y: rect.height / 2 + 10))
            trianglePath.addLine(to: CGPoint(x: 0, y: rect.height / 2))
        } else {
            trianglePath.move(to: CGPoint(x: rect.width - 10, y: rect.height / 2 - 10))
            trianglePath.addLine(to: CGPoint(x: rect.width - 10, y: rect.height / 2 + 10))
            trianglePath.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
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
        profileImageView.layer.cornerRadius = 20
        
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
        default:
            configureCommenterLayout()
        }
    }
    
    private func configureCreatorLayout() {
        commentView.tag = 0
        
        profileImageView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(CGSize(width: 50, height: 50))
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
            make.width.lessThanOrEqualTo(contentView).multipliedBy(0.7)
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
    
    func setUpCellData(with type: CommentType, data: Comment) {
        commentType = type
        
        let url = data.creator?.profileImage ?? ""
        //        print(data.profileImage, "🔥🔥🔥🔥🔥", url)
        let modifier = AnyModifier { request in
            var request = request
            request.setValue(APIAuth.catchSketchAPI.key, forHTTPHeaderField: Header.sesacKey.rawValue)
            request.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: Header.authorization.rawValue)
            
            return request
        }
        let commentCreatorImageUrl = URL(string: APIAuth.catchSketchAPI.baseURL + "/v1/" + url)
        print(commentCreatorImageUrl)
        profileImageView.kf.setImage(with: commentCreatorImageUrl, options: [.requestModifier(modifier)])
        profileImageView.kf.setImage(with: commentCreatorImageUrl, options: [.requestModifier(modifier)]) { [weak self] result in
            switch result {
            case .success(let data):
                self?.profileImageView.image = data.image
            case .failure(let error):
                print(error)
            }
        }
        nicknameLabel.text = data.creator?.nick
        commentLabel.text = data.content
        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commentView.setNeedsDisplay()
    }
}
