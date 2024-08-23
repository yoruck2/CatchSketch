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

class PostQuizViewController: BaseViewController<PostQuizView> {
    private let viewModel = PostQuizViewModel()
    private let disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = PostQuizViewModel.Input(
            drawButtonTapped: rootView.drawSketchButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.showDrawViewController
            .subscribe(onNext: { [weak self] drawing in
                self?.openDrawViewController(with: drawing)
            })
            .disposed(by: disposeBag)
        
        viewModel.currentImage
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] image in
                self?.updateQuizImage(image)
            })
            .disposed(by: disposeBag)
    }
    
    private func openDrawViewController(with drawing: PKDrawing?) {
        let drawViewModel = DrawViewModel(existingDrawing: drawing)
        let drawViewController = DrawViewController(rootView: DrawView(), viewModel: drawViewModel)
        drawViewController.saveCompletionHandler = { [weak self] drawing, image in
            self?.viewModel.updateDrawingAndImage(drawing, image)
        }
        navigationController?.pushViewController(drawViewController, animated: true)
    }
    
    private func updateQuizImage(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.rootView.quizImageView.contentMode = .scaleAspectFill
            self.rootView.quizImageView.clipsToBounds = true
            
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
