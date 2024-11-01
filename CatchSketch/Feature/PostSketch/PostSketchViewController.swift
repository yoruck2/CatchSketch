//
//  PostQuizViewController.swift
//  CatchSketch
//
//  Created by dopamint on 8/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import PencilKit
import SnapKit
import Then

class PostSketchViewController: BaseViewController<PostSketchView> {
    
    private let viewModel = PostSketchViewModel()
    private let disposeBag = DisposeBag()
    private var saveCompletionHandler: ((PKDrawing, UIImage) -> Void)?
    private let spring = UIImageView().then {
        $0.image = UIImage(resource: .spring1)
        $0.backgroundColor = .clear
        }
    private lazy var backButton = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                  style: .plain,
                                                  target: nil, action: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(spring)
        view.backgroundColor = .clear
        spring.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.horizontalEdges.equalTo(rootView)
            make.bottom.equalTo(rootView.snp.top).offset(76)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    override func bindViewModel() {
        let sketchData = Observable.create { [weak self] observer in
            self?.saveCompletionHandler = { drawing, image in
                observer.onNext((drawing, image))
            }
            return Disposables.create()
        }
        
        let input = PostSketchViewModel.Input(
            drawButtonTapped: rootView.drawSketchButton.rx.tap,
            postButtonTapped: rootView.sketchPostButton.rx.tap,
            backButtonTapped: rootView.backButton.rx.tap,
            drawingUpdated: sketchData,
            correctAnswerText: rootView.correctAnswerTextField.rx.text.orEmpty,
            quizImage: rootView.quizImageView.rx.observe(UIImage.self, "image")
        )
        
        let output = viewModel.transform(input: input)
        
        output.isPostValid
            .drive(rootView.sketchPostButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.correctAnswerText
            .bind(to: rootView.correctAnswerTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.showDrawViewController
            .drive(onNext: { [weak self] drawing in
                guard let self else { return }
                let drawVC = DrawViewController(rootView: DrawView(), initialDrawing: drawing)
                drawVC.saveCompletionHandler = self.saveCompletionHandler
                self.navigationController?.pushViewController(drawVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.currentImage
            .drive(onNext: { [weak self] image in
                self?.updateQuizImage(image)
            })
            .disposed(by: disposeBag)
        
        output.showAlert
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                let alert = CatchSketchAlertController.create()
                    .addMessage(message)
                    .addButton(title: "확인",style: .clear) { [weak self] () -> Void in
                        self?.dismiss(animated: true)
                    }
                self?.present(alert, animated: true)
                self?.showAlert(message: message)
            })
            .disposed(by: disposeBag)
        
        output.postResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    let alert = CatchSketchAlertController.create()
                        .addTitle("스케치 퀴즈 등록 완료! 😆")
                        .addButton(title: "확인",style: .filled) {
                            self?.dismiss(animated: true)
                        }
                    self?.present(alert, animated: true)
                case .failure(let error):
                    self?.showAlert(message: "포스트 등록 실패: \(error.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)
        
        output.backTrigger
            .drive(onNext: { [weak self] in
                print("🎉")
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateQuizImage(_ image: UIImage?) {
        guard let image = image else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let scaledImage = self.scaleImage(image, to: self.rootView.quizImageView.bounds.size)
            self.rootView.quizImageView.image = scaledImage
        }
    }
    
    private func scaleImage(_ image: UIImage, to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }

}
