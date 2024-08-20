//
//  BaseViewController.swift
//  CatchSketch
//
//  Created by dopamint on 7/22/24.
//

import UIKit

class BaseViewController<RootView: UIView>: UIViewController {
    
    let rootView: RootView
    
    init(rootView: RootView) {
        self.rootView = rootView
        super.init(nibName: .none, bundle: .none)
    }
    override func loadView() {
        view = rootView
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
    }
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureNavigationBar()
        configureViewController()
    }
    
    func configureViewController() {}
    func bind() {}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

