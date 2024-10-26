//
//  CatchSketchNavigationController.swift
//  CatchSketch
//
//  Created by dopamint on 8/19/24.
//

import UIKit

class CatchSketchNavigationController: UINavigationController {
    // MARK: push 될때 탭바를 가리는 기능
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    convenience init(_ rootViewController: UIViewController) {
        self.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
