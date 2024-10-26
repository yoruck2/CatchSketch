//
//  CatchSketchTabBarController.swift
//  CatchSketch
//
//  Created by dopamint on 8/19/24.
//

import UIKit
import Then
import RxSwift
import RxCocoa

final class CatchSketchTabBarController : UITabBarController {
    
    // TODO: 버튼 우선인식??-
    lazy var postButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70)).then {
        $0.backgroundColor = .mainGreen
        $0.layer.cornerRadius = 30
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowOffset = CGSize(width: 4, height: 4)
        $0.setTitle("+", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 50)
        $0.frame = CGRect(x: Int(tabBar.bounds.width)/2 - 35, y: -20, width: 70, height: 70)
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.addSubview(postButton)
        setupCustomTabBar()
        setUpTabbarItmes()
        bind()
    }
    private func setupCustomTabBar() {
        let shape = CAShapeLayer()
        
        tabBar.layer.insertSublayer(shape, at: 0)
        tabBar.itemWidth = 40
        tabBar.itemPositioning = .centered
        tabBar.itemSpacing = 180
        tabBar.tintColor = .darkGreen
    }
    
    func setUpTabbarItmes() {
        let mainFeedVC = CatchSketchNavigationController(MainFeedViewController(rootView: MainFeedView()))
        let profileVC = CatchSketchNavigationController(ProfileViewController(rootView: ProfileView()))
        
        setViewControllers([mainFeedVC, profileVC], animated: true)
        
        guard let items = tabBar.items else { return }
        let targetSize = CGSize(width: 30, height: 30)
        items[0].image = resizeImage(image: .home1, targetSize: targetSize)
        items[1].image = resizeImage(image: .trophy, targetSize: targetSize)
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        items[0].imageInsets = insets
        items[1].imageInsets = insets
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    private func bind() {
        postButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let postQuizVC = PostSketchViewController(rootView: PostSketchView())
                let navigationController = CatchSketchNavigationController(rootViewController: postQuizVC)
                
                navigationController.modalPresentationStyle = .overFullScreen
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - 탭바 깎기
//    func getPathForTabBar() -> UIBezierPath {
//        let frameWidth = self.tabBar.bounds.width
//        let frameHeight = self.tabBar.bounds.height + 20
//        let holeWidth = 150
//        let holeHeight = 50
//        let leftXUntilHole = Int(frameWidth/2) - Int(holeWidth/2)
//
//        let path : UIBezierPath = UIBezierPath()
//        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x: leftXUntilHole , y: 0)) // 1.Line
//        path.addCurve(to: CGPoint(x: leftXUntilHole + (holeWidth/3), y: holeHeight/2), controlPoint1: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*6,y: 0), controlPoint2: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*8, y: holeHeight/2)) // part I
//
//        path.addCurve(to: CGPoint(x: leftXUntilHole + (2*holeWidth)/3, y: holeHeight/2), controlPoint1: CGPoint(x: leftXUntilHole + (holeWidth/3) + (holeWidth/3)/3*2/5, y: (holeHeight/2)*6/4), controlPoint2: CGPoint(x: leftXUntilHole + (holeWidth/3) + (holeWidth/3)/3*2 + (holeWidth/3)/3*3/5, y: (holeHeight/2)*6/4)) // part II
//
//        path.addCurve(to: CGPoint(x: leftXUntilHole + holeWidth, y: 0), controlPoint1: CGPoint(x: leftXUntilHole + (2*holeWidth)/3,y: holeHeight/2), controlPoint2: CGPoint(x: leftXUntilHole + (2*holeWidth)/3 + (holeWidth/3)*2/8, y: 0)) // part III
//        path.addLine(to: CGPoint(x: frameWidth, y: 0)) // 2. Line
//        path.addLine(to: CGPoint(x: frameWidth, y: frameHeight)) // 3. Line
//        path.addLine(to: CGPoint(x: 0, y: frameHeight)) // 4. Line
//        path.addLine(to: CGPoint(x: 0, y: 0)) // 5. Line
//        path.close()
//        return path
//    }

