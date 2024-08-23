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
    let currentDrawing: BehaviorRelay<PKDrawing?>
    let currentImage: BehaviorRelay<UIImage?>
    
    struct Input {
        let drawButtonTapped: Observable<Void>
    }
    
    struct Output {
        let showDrawViewController: Observable<PKDrawing?>
    }
    
    init() {
        self.currentDrawing = BehaviorRelay<PKDrawing?>(value: nil)
        self.currentImage = BehaviorRelay<UIImage?>(value: nil)
    }
    
    func transform(input: Input) -> Output {
        let showDrawViewController = input.drawButtonTapped
            .withLatestFrom(currentDrawing)
        
        return Output(showDrawViewController: showDrawViewController)
    }
    
    func updateDrawingAndImage(_ drawing: PKDrawing, _ image: UIImage) {
        currentDrawing.accept(drawing)
        currentImage.accept(image)
    }
}


