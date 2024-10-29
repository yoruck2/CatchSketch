//
//  SketchQuizViewController.swift
//  CatchSketch
//
//  Created by dopamint on 8/28/24.
//

import UIKit
import Toast
import RxSwift
import RxCocoa

final class SketchQuizViewController: BaseViewController<SketchQuizView> {
    private let disposeBag = DisposeBag()
    private let viewModel: SketchQuizViewModel
    private var currentAlert: CatchSketchAlertController?
    
    init(data: PostResponse.Post) {
        viewModel = SketchQuizViewModel(postData: data)
        
        super.init(rootView: SketchQuizView())
        rootView.commentCollectionView.register(CommentCollectionViewCell.self,
                                                forCellWithReuseIdentifier: CommentCollectionViewCell.identifier)
        guard let imageUrl = data.files?.first else { return }
        rootView.sketchImageView.setImageWithToken(urlString: imageUrl,
                                                   placeholder: UIImage(systemName: "photo"))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func bindViewModel() {
        let input = SketchQuizViewModel.Input(catchButtonTapped: rootView.catchButton.rx.tap, 
                                              backButtonTapped: rootView.backButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.commentData
            .bind(to: rootView.commentCollectionView.rx.items(cellIdentifier: CommentCollectionViewCell.identifier,
                                                              cellType: CommentCollectionViewCell.self)) {
                (row, comment, cell) in
                if comment.creator?.user_id == self.viewModel.creator.user_id {
                    cell.setUpCellData(with: .creator, data: comment)
                } else {
                    cell.setUpCellData(with: .commenter, data: comment)
                }
            }.disposed(by: disposeBag)
        
        output.dismissTrigger
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.showAlert
            .bind { [weak self] alert in
                self?.currentAlert = alert
                self?.currentAlert?.modalTransitionStyle = .coverVertical
                self?.present(alert, animated: true)
            }.disposed(by: disposeBag)
        
        output.alertAction
            .bind { [weak self] action in
                switch action {
                case .cancel:
                    self?.currentAlert?.dismiss(animated: true)
                case .confirm(let message):
                    
                    self?.currentAlert?.dismiss(animated: true)
                    
                case .showToast(let message):
                    self?.view.makeToast(message)
                    if let alertController = self?.presentedViewController as? CatchSketchAlertController {
                        alertController.view.shake()
                    }
                }
            }.disposed(by: disposeBag)
    }
}
