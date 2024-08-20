//
//  MainFeedView.swift
//  CatchSketch
//
//  Created by dopamint on 8/19/24.
//

import UIKit
import SnapKit

class MainFeedView: BaseView {
    
    lazy var mainFeedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CenteredCollectionViewFlowLayout()).then {
        let height = UIScreen.main.bounds.height
        $0.backgroundColor = .white
        $0.decelerationRate = .fast
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: height * 0.2, left: 0, bottom: height * 0.2, right: 0)
    }
    override func configureLayout() {
        addSubview(mainFeedCollectionView)
        mainFeedCollectionView.snp.makeConstraints { $0.edges.equalTo(safeAreaLayoutGuide) }
    }
}

class CenteredCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        let height = UIScreen.main.bounds.height
        itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: height * 0.6)
        minimumLineSpacing = 20
        scrollDirection = .vertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView,
              let layoutAttributes = layoutAttributesForElements(in: CGRect(origin: proposedContentOffset, size: collectionView.bounds.size)) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let verticalCenter = proposedContentOffset.y + collectionView.bounds.height / 2
        let closestAttribute = layoutAttributes.min(by: {
            abs($0.center.y - verticalCenter) < abs($1.center.y - verticalCenter)
        })
        
        guard let targetAttribute = closestAttribute else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        return CGPoint(x: proposedContentOffset.x, y: targetAttribute.center.y - collectionView.bounds.height / 2)
    }
}
