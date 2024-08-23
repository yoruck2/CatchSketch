//
//  CatchSketchTabBarController.swift
//  CatchSketch
//
//  Created by dopamint on 8/19/24.
//

import UIKit

final class CatchSketchTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainFeedVC = CatchSketchNavigationController(MainFeedViewController(rootView: MainFeedView()))
        let postQuizVC = CatchSketchNavigationController(PostQuizViewController(rootView: PostQuizView()))
        let profileVC = CatchSketchNavigationController(ProfileViewController(rootView: ProfileView()))
        
        setViewControllers([mainFeedVC, postQuizVC, profileVC], animated: true)
        
        setupTabBarAppearance()
        setupTabBarItems()
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        if let tornPaperImage = UIImage(named: CatchSketch.AssetImage.tornPaper) {
            let adjustedImage = adjustBackgroundImage(tornPaperImage, for: tabBar)
            appearance.backgroundColor = UIColor(patternImage: adjustedImage)
        }
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.tintColor = CatchSketch.Color.mainGreen
    }
    
    private func adjustBackgroundImage(_ image: UIImage, for tabBar: UITabBar) -> UIImage {
        let tabBarHeight = tabBar.frame.size.height
        let imageHeight = image.size.height
        let yOffset: CGFloat = -30 // 이 값을 조정하여 이미지 위치를 변경합니다
        
        UIGraphicsBeginImageContextWithOptions(tabBar.frame.size, false, 0)
        image.draw(in: CGRect(x: 0, y: yOffset, width: tabBar.frame.width, height: imageHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }
    
    private func setupTabBarItems() {
        guard let items = tabBar.items else { return }
        
        items[0].image = UIImage(systemName: CatchSketch.SystemImage.pictures)
        items[1].image = UIImage(systemName: CatchSketch.SystemImage.post)
        items[2].image = UIImage(systemName: CatchSketch.SystemImage.profile)
    }
}

// 버튼 탭바

//class CatchSketchTabBarController: UITabBarController, UITabBarControllerDelegate {
//    
//    private var middleButton: UIButton!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.delegate = self
//        
//        let mainFeedVC = CatchSketchNavigationController(MainFeedViewController(rootView: MainFeedView()))
//        let postQuizVC = CatchSketchNavigationController(PostQuizViewController(rootView: PostQuizView()))
//        let profileVC = CatchSketchNavigationController(ProfileViewController(rootView: ProfileView()))
//        
//        setViewControllers([mainFeedVC, postQuizVC, profileVC], animated: true)
//        
//        setupCustomTabBar()
//        setupTabBarAppearance()
//        setupTabBarItems()
//        setupMiddleButton()
//    }
//    
//    private func setupCustomTabBar() {
//        let customTabBar = CustomTabBar()
//        self.setValue(customTabBar, forKey: "tabBar")
//    }
//    
//    private func setupTabBarAppearance() {
//        if let tornPaperImage = UIImage(named: CatchSketch.AssetImage.tornPaper) {
//            let adjustedImage = adjustBackgroundImage(tornPaperImage, for: tabBar)
//            tabBar.backgroundImage = adjustedImage
//        }
//        
//        tabBar.tintColor = CatchSketch.Color.mainGreen
//    }
//    
//    private func adjustBackgroundImage(_ image: UIImage, for tabBar: UITabBar) -> UIImage {
//        let tabBarHeight = tabBar.frame.size.height
//        let imageHeight = image.size.height
//        let yOffset: CGFloat = -30 // 이 값을 조정하여 이미지 위치를 변경합니다
//        
//        UIGraphicsBeginImageContextWithOptions(tabBar.frame.size, false, 0)
//        image.draw(in: CGRect(x: 0, y: yOffset, width: tabBar.frame.width, height: imageHeight))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return newImage ?? image
//    }
//    
//    private func setupTabBarItems() {
//        guard let items = tabBar.items else { return }
//        
//        items[0].image = UIImage(systemName: CatchSketch.SystemImage.pictures)
//        items[1].image = UIImage(systemName: CatchSketch.SystemImage.post)
//        items[2].image = UIImage(systemName: CatchSketch.SystemImage.profile)
//    }
//    
//    private func setupMiddleButton() {
//        middleButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 25, y: -20, width: 50, height: 50))
//        
//        middleButton.backgroundColor = .blue
//        middleButton.layer.cornerRadius = middleButton.frame.height / 2
//        
//        self.tabBar.addSubview(middleButton)
//        middleButton.addTarget(self, action: #selector(middleButtonAction), for: .touchUpInside)
//        
//        self.view.layoutIfNeeded()
//    }
//    
//    @objc private func middleButtonAction() {
//        // 여기에 중간 버튼을 눌렀을 때의 동작을 구현하세요
//        print("중간 버튼이 눌렸습니다")
//    }
//}
