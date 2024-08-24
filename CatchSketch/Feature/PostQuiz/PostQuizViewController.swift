//
//  PostQuizViewController.swift
//  CatchSketch
//
//  Created by dopamint on 8/19/24.
//

import UIKit
import RxSwift
import PencilKit

class PostQuizViewController: BaseViewController<PostQuizView> {
    private let viewModel = PostQuizViewModel()
    private let disposeBag = DisposeBag()
    private var saveCompletionHandler: ((PKDrawing, UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = PostQuizViewModel.Input(
            drawButtonTapped: rootView.drawSketchButton.rx.tap,
            drawingUpdated: Observable.create { [weak self] observer in
                self?.saveCompletionHandler = { drawing, image in
                    observer.onNext((drawing, image))
                }
                return Disposables.create()
            }
        )
        
        let output = viewModel.transform(input: input)
        
        output.showDrawViewController
            .drive { [weak self] drawing in
                self?.openDrawViewController(with: drawing)
            }
            .disposed(by: disposeBag)
        
        output.currentImage
            .drive { [weak self] image in
                self?.updateQuizImage(image)
            }
            .disposed(by: disposeBag)
    }
    
    private func openDrawViewController(with drawing: PKDrawing?) {
        let drawVC = DrawViewController(rootView: DrawView(), initialDrawing: drawing)
        
        drawVC.saveCompletionHandler = self.saveCompletionHandler
        navigationController?.pushViewController(drawVC, animated: true)
    }
    
    private func updateQuizImage(_ image: UIImage?) {
        guard let image = image else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
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
