//
//  SketchQuizViewController.swift
//  CatchSketch
//
//  Created by dopamint on 8/28/24.
//

import UIKit
import RxSwift
import RxCocoa


class SketchQuizViewController: BaseViewController<SketchQuizView> {
    private let disposeBag = DisposeBag()
    private let viewModel: SketchQuizViewModel

    init(data: [Comment]) {
        viewModel = SketchQuizViewModel(data: data)
        
        super.init(rootView: SketchQuizView())
        rootView.commentCollectionView.register(CommentCollectionViewCell.self,
                                                forCellWithReuseIdentifier: "CommentCollectionViewCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bindViewModel() {
        let input = SketchQuizViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.commentData
            .bind(to: rootView.commentCollectionView.rx.items(cellIdentifier: "CommentCollectionViewCell",
                                                              cellType: CommentCollectionViewCell.self)) { 
                (row, comment, cell) in
                print("✨")
                print(comment)
                cell.setUpCellData(with: .creator, data: comment)
            }.disposed(by: disposeBag)
    }
}
