//
//  MainFeedView.swift
//  CatchSketch
//
//  Created by dopamint on 8/19/24.
//

import UIKit
import SnapKit

class MainFeedView: BaseView {
    
    lazy var mainFeedCollectionView: UICollectionView = {
        let layout = CenteredCollectionViewFlowLayout()
        let height = UIScreen.main.bounds.height
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: height * 0.6)
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.decelerationRate = .fast
        collectionView.showsVerticalScrollIndicator = false

        collectionView.contentInset = UIEdgeInsets(top: height * 0.1, left: 0, bottom: height * 0.1, right: 0)
        return collectionView
    }()
    
    override func configureLayout() {
        addSubview(mainFeedCollectionView)
        
        mainFeedCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
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

