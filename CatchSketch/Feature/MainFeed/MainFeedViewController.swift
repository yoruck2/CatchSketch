//
//  MainFeedViewController.swift
//  CatchSketch
//
//  Created by dopamint on 8/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import Then

final class MainFeedViewController: BaseViewController<MainFeedView> {
    private let viewModel = MainFeedViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.mainFeedCollectionView.register(MainFeedCollectionViewCell.self, forCellWithReuseIdentifier: MainFeedCollectionViewCell.identifier)
        setupRefreshTokenExpiredHandler()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        rootView.mainFeedCollectionView.refreshControl = refreshControl
        setupRefreshControl()
        viewModel.loadInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        viewModel.loadInitialData()
    }
    @objc private func refreshData() {
        viewModel.refreshData()
    }
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        rootView.mainFeedCollectionView.refreshControl = refreshControl
    }
    
    
    override func bindViewModel() {
        rootView.profileButton.setImageWithToken(urlString: UserDefaultsManager.shared.userData?.profileImage ?? "",
                                                 placeholder: UIImage(systemName: "person.circle"))
        let refreshTrigger = rootView.mainFeedCollectionView.refreshControl?.rx.controlEvent(.valueChanged).asObservable() ?? Observable.empty()
        
        let input = MainFeedViewModel.Input(
            refreshTrigger: refreshTrigger,
            postSelected: rootView.mainFeedCollectionView.rx.modelSelected(PostResponse.Post.self),
            prefetchingItem: rootView.mainFeedCollectionView.rx.prefetchItems,
            didScroll: rootView.mainFeedCollectionView.rx.didScroll
        )
        let output = viewModel.transform(input: input)
        
        output.posts
            .bind(to: rootView.mainFeedCollectionView.rx.items(cellIdentifier: MainFeedCollectionViewCell.identifier,
                                                               cellType: MainFeedCollectionViewCell.self)) { (row, post, cell) in
                cell.configure(with: post)
            }
                                                               .disposed(by: disposeBag)
        
        output.refreshResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.rootView.mainFeedCollectionView.refreshControl?.endRefreshing()
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
        
        output.isRefreshing
            .bind(to: rootView.mainFeedCollectionView.refreshControl?.rx.isRefreshing ?? Binder(self) { _, _ in })
            .disposed(by: disposeBag)
        
        output.userInfo
            .bind(with: self) { owner, value in
                owner.rootView.userInfoView.setUpData(data: value)
            }
            .disposed(by: disposeBag)
    }
}

