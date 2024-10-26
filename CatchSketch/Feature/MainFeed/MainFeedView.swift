//
//  MainFeedView.swift
//  CatchSketch
//
//  Created by dopamint on 8/19/24.
//

import UIKit
import SnapKit
import Then

class MainFeedView: BaseView {
    
    private let backgroundImageView = UIImageView().then {
        $0.image = UIImage(resource: .paper1)
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let mainNavigation = UIImageView().then {
        $0.image = UIImage(resource: .reversedTornSketchbook)
        $0.isUserInteractionEnabled = true
    }
    let logoImage = UIImageView().then {
        $0.image = UIImage(resource: .logo2)
    }
    
    let profileButton = UIImageView().then {
        $0.image = UIImage(systemName: "person.circle")
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
    }
    
    lazy var mainFeedCollectionView: UICollectionView = {
        let layout = CenteredCollectionViewFlowLayout()
        let height = UIScreen.main.bounds.height
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: height * 0.6)
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.showsVerticalScrollIndicator = false

        collectionView.contentInset = UIEdgeInsets(top: height * 0.1, left: 0, bottom: height * 0.1, right: 0)
        return collectionView
    }()
    
    override func configureHierarchy() {
        addSubview(backgroundImageView)
        addSubview(mainFeedCollectionView)
        addSubview(mainNavigation)
        mainNavigation.addSubview(logoImage)
        mainNavigation.addSubview(profileButton)
        
    }
    
    override func configureLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainFeedCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        mainNavigation.snp.makeConstraints { make in

            make.bottom.equalTo(safeAreaLayoutGuide.snp.top).offset(60)
            make.width.equalToSuperview().multipliedBy(1.1)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        logoImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(35)
            make.bottom.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(90)
        }
        profileButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(38)
            make.bottom.equalToSuperview().inset(25)
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
    }
}

class CenteredCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
        
        let targetRect = CGRect(x: 0, y: proposedContentOffset.y, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let verticalCenter = proposedContentOffset.y + collectionView.bounds.size.height / 2
        
        for layoutAttributes in rectAttributes {
            let itemVerticalCenter = layoutAttributes.center.y
            if (itemVerticalCenter - verticalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemVerticalCenter - verticalCenter
            }
        }
        return CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y + offsetAdjustment)
    }
}

