//
//  MainFeedViewController.swift
//  CatchSketch
//
//  Created by dopamint on 8/19/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MainFeedViewController: BaseViewController<MainFeedView> {
    private let viewModel = MainFeedViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.mainFeedCollectionView.register(MainFeedCollectionViewCell.self, forCellWithReuseIdentifier: "MainFeedCell")
        
        setupRefreshTokenExpiredHandler()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = MainFeedViewModel.Input(viewDidLoadTrigger: rx.viewWillAppear.asObservable())
        let output = viewModel.transform(input: input)
        
        viewModel.items
            .bind(to: rootView.mainFeedCollectionView.rx.items(cellIdentifier: "MainFeedCell", cellType: MainFeedCollectionViewCell.self)) { (row, element, cell) in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        rootView.mainFeedCollectionView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak self] item in
//                NetworkService.shared.logIn(query: .post(.postView()))
//                    .subscribe()
//                    .disposed(by: self?.disposeBag ?? DisposeBag())
                self?.showAlert(title: "눌림", message: "확인")
            })
            .disposed(by: disposeBag)
        
        output.refreshResult
            .bind(with: self) { owner, value in
                switch value {
                case .success(let value):
                    print("🔥🔥🔥🔥🔥")
                    dump(value)
                case .failure(let error):
                    
                    print("토큰갱신 실패")
                    print(error.localizedDescription)
                }
            }.disposed(by: disposeBag)
    }
}
//http://lslp.sesac.co.kr:31819/v1/posts/posts?limit=nil&next=nil
//http://lslp.sesac.co.kr:31819/v1/posts?limit=100&next=66c36c8ed46f4af131d9cf86
