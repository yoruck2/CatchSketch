//
//  UIViewController+.swift
//  CatchSketch
//
//  Created by dopamint on 8/19/24.
//

import UIKit

extension UIViewController {
    
    func changeRootViewController(_ viewController: UIViewController) {
 
        if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
        let window = scene.window {
            window.rootViewController = viewController
            UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil, completion: nil)
        }
    }
    
    func showAlert(title: String,
                   message: String,
                   preferredStyle: UIAlertController.Style = .alert,
                   actions: [UIAlertAction] = [],
                   completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: preferredStyle)
            for action in actions {
                alert.addAction(action)
            }
            if actions.isEmpty {
                let okAction = UIAlertAction(title: "확인",
                                             style: .default,
                                             handler: nil)
                alert.addAction(okAction)
            }
            
            self.present(alert, animated: true, completion: completion)
        }
    }
    
    func setupRefreshTokenExpiredHandler() {
        NetworkService.shared.refreshTokenExpired = { [weak self] in
            let loginVC = LogInViewController(rootView: LogInView())
            self?.changeRootViewController(loginVC)
        }
    }
}
