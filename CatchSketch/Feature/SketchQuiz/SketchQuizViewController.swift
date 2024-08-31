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
    private var currentAlert: CatchSketchAlertController?
    
    init(data: Post) {
        viewModel = SketchQuizViewModel(postData: data)
        
        super.init(rootView: SketchQuizView())
        rootView.commentCollectionView.register(CommentCollectionViewCell.self,
                                                forCellWithReuseIdentifier: "CommentCollectionViewCell")
        guard let imageUrl = data.files?.first else { return }
        rootView.sketchImageView.setImageWithToken(urlString: imageUrl,
                                                   placeholder: UIImage(systemName: "photo"))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bindViewModel() {
        let input = SketchQuizViewModel.Input(catchButtonTap: rootView.catchButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.commentData
            .bind(to: rootView.commentCollectionView.rx.items(cellIdentifier: "CommentCollectionViewCell",
                                                              cellType: CommentCollectionViewCell.self)) {
                (row, comment, cell) in
                if comment.creator?.user_id == self.viewModel.creator.user_id {
                    cell.setUpCellData(with: .creator, data: comment)
                } else {
                    cell.setUpCellData(with: .commenter, data: comment)
                }
                
            }.disposed(by: disposeBag)
        
        output.showAlert
            .bind { [weak self] alert in
                self?.currentAlert = alert
                self?.present(alert, animated: true)
            }.disposed(by: disposeBag)
        
        output.alertAction
            .bind { [weak self] action in
                switch action {
                case .cancel:
                    self?.currentAlert?.dismiss(animated: true)
                case .confirm(let text):
                    self?.currentAlert?.dismiss(animated: true)
                    print("Confirmed with text: \(text)")
                    // 여기서 확인 액션에 대한 추가 처리를 할 수 있습니다.
                }
            }.disposed(by: disposeBag)
    }
}
