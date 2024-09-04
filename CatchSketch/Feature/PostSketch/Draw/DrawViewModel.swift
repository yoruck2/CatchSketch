//
//  DrawViewModel.swift
//  CatchSketch
//
//  Created by dopamint on 8/23/24.
//

import RxSwift
import RxCocoa
import PencilKit


class DrawViewModel: BaseViewModel {
    struct Input {
        let saveButtonTapped: ControlEvent<Void>
        let backButtonTapped: ControlEvent<Void>
        let drawingChanged: PublishSubject<PKDrawing>
        let viewWillAppear: ControlEvent<Bool>
        let canvasBounds: BehaviorSubject<CGRect>
        let initialDrawing: PKDrawing?
    }
    
    struct Output {
        let initialDrawing: Driver<PKDrawing?>
        let dismissTrigger: Driver<Void>
        let savedDrawingAndImage: Driver<(PKDrawing, UIImage)>
        let showBackAlert: Driver<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let initialDrawingDriver = input.viewWillAppear
            .take(1)
            .map { _ in input.initialDrawing }
            .asDriver(onErrorJustReturn: nil)
        
        let dismissTrigger = input.saveButtonTapped
            .asDriver(onErrorJustReturn: ())
        
        let showBackAlert = input.backButtonTapped
            .asDriver(onErrorJustReturn: ())
        
        let savedDrawingAndImage = input.saveButtonTapped
            .withLatestFrom(Observable.combineLatest(input.drawingChanged, 
                                                     input.canvasBounds))
            .compactMap { drawing, bounds -> (PKDrawing, UIImage)? in
                let image = drawing.image(from: bounds, scale: 1)
                return (drawing, image)
            }
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(
            initialDrawing: initialDrawingDriver,
            dismissTrigger: dismissTrigger,
            savedDrawingAndImage: savedDrawingAndImage,
            showBackAlert: showBackAlert
        )
    }
}
