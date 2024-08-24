//
//  PostQuizViewModel.swift
//  CatchSketch
//
//  Created by dopamint on 8/23/24.
//

import Foundation
import RxSwift
import RxCocoa
import PencilKit
import UIKit

class PostQuizViewModel {
    struct Input {
        let drawButtonTapped: ControlEvent<Void>
        let drawingUpdated: Observable<(PKDrawing, UIImage)>
    }
    
    struct Output {
        let currentDrawing: Driver<PKDrawing?>
        let currentImage: Driver<UIImage?>
        let showDrawViewController: Driver<PKDrawing?>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let drawingRelay = BehaviorRelay<PKDrawing?>(value: nil)
        let imageRelay = BehaviorRelay<UIImage?>(value: nil)
        
        input.drawingUpdated
            .subscribe(onNext: { drawing, image in
                drawingRelay.accept(drawing)
                imageRelay.accept(image)
            })
            .disposed(by: disposeBag)
        
        let showDrawViewController = input.drawButtonTapped
            .withLatestFrom(drawingRelay)
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(
            currentDrawing: drawingRelay.asDriver(),
            currentImage: imageRelay.asDriver(),
            showDrawViewController: showDrawViewController
        )
    }
}
