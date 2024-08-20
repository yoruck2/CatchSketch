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
        
        bindViewModel()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let layout = rootView.mainFeedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let firstItemOffset = layout.itemSize.height / 2 - rootView.mainFeedCollectionView.frame.size.height / 2
            rootView.mainFeedCollectionView.setContentOffset(CGPoint(x: 0, y: -rootView.mainFeedCollectionView.contentInset.top + firstItemOffset+160), animated: true)
        }
    }
    private func bindViewModel() {
        viewModel.items
            .bind(to: rootView.mainFeedCollectionView.rx.items(cellIdentifier: "MainFeedCell", cellType: MainFeedCollectionViewCell.self)) { (row, element, cell) in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        rootView.mainFeedCollectionView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak self] item in
                self?.showAlert(with: item)
            })
            .disposed(by: disposeBag)
    }
    
    private func showAlert(with item: String) {
        let alert = UIAlertController(title: "눌림", message: item, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
