//
//  DrawViewModel.swift
//  CatchSketch
//
//  Created by dopamint on 8/23/24.
//

import Foundation
import RxSwift
import RxCocoa
import PencilKit
import UIKit

class DrawViewModel {
    let initialDrawing: BehaviorRelay<PKDrawing?>
    let currentDrawing: BehaviorRelay<PKDrawing?>
    
    struct Input {
        let saveButtonTapped: Observable<Void>
        let drawingChanged: Observable<PKDrawing>
    }
    
    struct Output {
        let dismissTrigger: Observable<Void>
        let savedDrawingAndImage: Observable<(PKDrawing, UIImage)>
    }
    
    init(existingDrawing: PKDrawing? = nil) {
        self.initialDrawing = BehaviorRelay<PKDrawing?>(value: existingDrawing)
        self.currentDrawing = BehaviorRelay<PKDrawing?>(value: existingDrawing)
    }
    
    func transform(input: Input) -> Output {
        let dismissTrigger = input.saveButtonTapped
        
        input.drawingChanged
            .bind(to: currentDrawing)
            .disposed(by: DisposeBag())
        
        let savedDrawingAndImage = input.saveButtonTapped
            .withLatestFrom(currentDrawing)
            .compactMap { drawing -> (PKDrawing, UIImage)? in
                guard let drawing = drawing else { return nil }
                let image = drawing.image(from: drawing.bounds, scale: UIScreen.main.scale)
                return (drawing, image)
            }
        
        return Output(dismissTrigger: dismissTrigger, savedDrawingAndImage: savedDrawingAndImage)
    }
}
