//
//  SketchQuizViewModel.swift
//  CatchSketch
//
//  Created by dopamint on 8/28/24.
//

import Foundation
import RxSwift
import RxCocoa

class SketchQuizViewModel {
    
    enum AlertAction {
        case cancel
        case confirm(String)
    }
    
    let disposeBag = DisposeBag()
    
    let creator: Creator
    let answer: String
    var output: Output
    
    init(postData: Post) {
        
        guard let comments = postData.comments,
              let creator = postData.creator,
              let answer = postData.content else { return }
        output = Output(commentData: BehaviorSubject(value: []))
        output.commentData.onNext(comments)
        self.creator = creator
        self.answer = answer
    }
    
    struct Input {
        let catchButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let commentData: BehaviorSubject<[Comment]>
        var showAlert = Observable<CatchSketchAlertController>.empty()
        let alertAction = PublishSubject<AlertAction>()
    }
        
    func transform(input: Input) -> Output {
        
        output.showAlert = input.catchButtonTap
            .map { [weak self] _ in
                guard let self else { return CatchSketchAlertController.create() }
                return CatchSketchAlertController.create()
                    .addTitle("정답 제시")
                    .addTextField(placeholder: "여기에 입력하세요")
                    .addButton(title: "취소", style: .clear) {
                        self.output.alertAction.onNext(.cancel)
                    }
                    .addButton(title: "확인", style: .filled) {
                        
//                        if let text = self.getAlertText() {
//                            self.alertActionSubject.onNext(.confirm(text))
//                        }
                    }
            }
        return output
    }
}
