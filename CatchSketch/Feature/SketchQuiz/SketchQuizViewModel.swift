//
//  SketchQuizViewModel.swift
//  CatchSketch
//
//  Created by dopamint on 8/28/24.
//

import Foundation
import RxSwift

class SketchQuizViewModel {
    
    let disposeBag = DisposeBag()
    let data = BehaviorSubject<[Comment]>(value: [])
    
    init(data: [Comment]) {
        self.data.onNext(data) // 1
    }
    
    struct Input {
        
    }
    
    struct Output {
        let commentData: Observable<[Comment]>
    }
    
    func transform(input: Input) -> Output {
        
        return Output(commentData: data) // 4
    }
}
