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
    }
    
    override func bindViewModel() {
        let input = MainFeedViewModel.Input(viewWillAppearTrigger: rx.viewWillAppear.asObservable().map { _ in },
                                            postSelected: rootView.mainFeedCollectionView.rx.modelSelected(PostResponse.Post.self))
        let output = viewModel.transform(input: input)
        
        output.posts
            .bind(to: rootView.mainFeedCollectionView.rx.items(cellIdentifier: "MainFeedCell",
                                                               cellType: MainFeedCollectionViewCell.self)) { (row, post, cell) in
                cell.configure(with: post)
            }
            .disposed(by: disposeBag)
        
        output.refreshResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    print("✨ 피드 갱신 성공")
                    dump(response)
                case .failure(let error):
                    print("❌ 피드 갱신 실패: \(error.localizedDescription)")
                    self?.showAlert(title: "오류", message: "피드를 불러오는 데 실패했습니다.")
                }
            })
            .disposed(by: disposeBag)
        
        output.modelSelected
            .bind(with: self) { owner, vc in
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.nextCursor
            .subscribe(onNext: { cursor in
                print("Next cursor: \(cursor ?? "None")")
                
            })
            .disposed(by: disposeBag)
    }
}

