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

