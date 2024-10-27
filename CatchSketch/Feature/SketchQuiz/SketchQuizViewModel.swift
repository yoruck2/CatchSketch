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
        case showToast(String)
    }
    
    let disposeBag = DisposeBag()
    let postID: String
    let creator: PostResponse.Creator
    let answer: String
    var output: Output
    
    init(postData: PostResponse.Post) {
        guard let comments = postData.comments,
              let creator = postData.creator,
              let postID = postData.post_id,
              let answer = postData.content else {
            fatalError("Invalid post data")
        }
        self.creator = creator
        self.postID = postID
        self.answer = answer
        self.output = Output(commentData: BehaviorRelay(value: comments))
    }
    
    struct Input {
        let catchButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let commentData: BehaviorRelay<[PostResponse.Comment]>
        var showAlert = PublishRelay<CatchSketchAlertController>()
        let alertAction = PublishSubject<AlertAction>()
        let networkError = PublishSubject<Error>()
    }
    
    func transform(input: Input) -> Output {
        
        input.catchButtonTap
            .map { [weak self] _ -> CatchSketchAlertController in
                guard let self = self else { return CatchSketchAlertController.create() }
                
                return CatchSketchAlertController.create()
                    .addTitle("정답 제시")
                    .addTextField(placeholder: "여기에 입력하세요")
                    .addButton(title: "취소", style: .clear) { [weak self] in
                        self?.output.alertAction.onNext(.cancel)
                    }
                    .addButton(title: "확인", style: .filled, rxHandler: { [weak self] text -> Observable<String> in
                        guard let self = self else { return Observable.empty() }
                        return self.postComment(text: text)
                    })
            }
            .bind(to: output.showAlert)
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func postComment(text: String) -> Observable<String> {
        let comment = PostRequest.Comment(content: text)
        return NetworkService.shared.postComment(query: .post(.postComment(comment: comment, postID: postID)))
            .asObservable()
            .flatMap { [weak self] result -> Observable<String> in
                guard let self = self else { return Observable.empty() }
                switch result {
                case .success(let commentResponse):
                    // UI 업데이트
                    var currentComments = self.output.commentData.value
                    currentComments.append(commentResponse)
                    let orderedComments = currentComments
                        .sorted { $0.createdAt.toDate() > $1.createdAt.toDate() }
                    self.output.commentData.accept(orderedComments)
                        
                    // 업데이트된 전체 게시물 정보 가져오기
                    return self.fetchUpdatedPost()
                case .failure(let error):
                    self.output.networkError.onNext(error)
                    return Observable.error(error)
                }
            }
            .catchAndReturn("")
    }
    
    private func fetchUpdatedPost() -> Observable<String> {
        return NetworkService.shared.getSpecificPost(query: .post(.postView(productID: postID)))
            .asObservable()
            .flatMap { [weak self] result -> Observable<String> in
                guard let self = self else { return Observable.empty() }
                switch result {
                case .success(let updatedPost):
                    if let comments = updatedPost.comments {
                        self.output.commentData.accept(comments)
                    }
                    return Observable.just("")
                case .failure(let error):
                    self.output.networkError.onNext(error)
                    return Observable.error(error)
                }
            }
    }
}
