//
//  SketchQuizViewModel.swift
//  CatchSketch
//
//  Created by dopamint on 8/28/24.
//

import Foundation
import RxSwift
import RxCocoa
import Toast
// TODO: 글 삭제 기능

final class SketchQuizViewModel {
    enum AlertAction {
        case cancel
        case confirm(String)
        case showToast(String)
    }
    
    private let disposeBag = DisposeBag()
    private let postID: String
    let creator: PostResponse.Creator
    private let answer: String
    private let commentDataRelay = BehaviorRelay<[PostResponse.Comment]>(value: [])
    private let alertRelay = PublishRelay<CatchSketchAlertController>()
    private let toastAlertSubject = PublishSubject<AlertAction>()
    private let networkErrorSubject = PublishSubject<Error>()
    var isSolved = BehaviorRelay<Bool>(value: false)
    
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
        self.commentDataRelay.accept(comments)
    }
    
    struct Input {
        let catchButtonTapped: ControlEvent<Void>
        let backButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let commentData: Observable<[PostResponse.Comment]>
        let showAlert: Observable<CatchSketchAlertController>
        let alertAction: Observable<AlertAction>
        let networkError: Observable<Error>
        let dismissTrigger: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        input.catchButtonTapped
            .map { [weak self] _ -> CatchSketchAlertController in
                guard let self = self else { return CatchSketchAlertController.create() }
                
                return CatchSketchAlertController.create()
                    .addTitle("정답 제시")
                    .addTextField(placeholder: "여기에 입력하세요")
                    .addButton(title: "취소", style: .clear) { [weak self] in
                        self?.toastAlertSubject.onNext(.cancel)
                    }
                    .addButton(title: "확인", style: .filled, rxHandler: { [weak self] text -> Observable<String> in
                        guard let self else { return Observable.empty() }
                        
                        if answer == text {
                            // 1. isSolved 상태를 true로 변경
                            self.isSolved.accept(true)
                            
                            // 2. 토스트 메시지 표시를 위한 이벤트 발생
                            self.toastAlertSubject.onNext(.showToast("정답입니다! 🎉\n경험치 + 20"))
                            
                            // 3. 좋아요 상태 변경 네트워크 요청
                            NetworkService.shared.toggleLike(query: .post(.like(postID: postID, isLike: Like(like_status: true))))
                                .subscribe()
                                .disposed(by: self.disposeBag)
//                            NetworkService.shared.editProfile(query: .profile(.edit(data: ProfileRequest.Edit(birthDay: ))))
//                                .subscribe()
//                                .disposed(by: self.disposeBag)
                            
                            // 4. 정답 댓글 작성 후 응답 리턴
                            return self.postComment(text: text)
                        } else {
                            // 오답인 경우 토스트 메시지 표시
                            self.toastAlertSubject.onNext(.showToast("틀렸습니다. 다시 시도해보세요!"))
                            return self.postComment(text: text)
                        }
                    })
            }
            .bind(to: alertRelay)
            .disposed(by: disposeBag)
        
        return Output(
            commentData: commentDataRelay.asObservable(),
            showAlert: alertRelay.asObservable(),
            alertAction: toastAlertSubject.asObservable(),
            networkError: networkErrorSubject.asObservable(),
            dismissTrigger: input.backButtonTapped.asObservable()
        )
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
                    var currentComments = self.commentDataRelay.value
                    currentComments.append(commentResponse)
                    let orderedComments = currentComments
                        .sorted { $0.createdAt.toDate() > $1.createdAt.toDate() }
                    self.commentDataRelay.accept(orderedComments)
                    
                    // 업데이트된 전체 게시물 정보 가져오기
                    return self.fetchUpdatedPost()
                case .failure(let error):
                    self.networkErrorSubject.onNext(error)
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
                        self.commentDataRelay.accept(comments)
                    }
                    return Observable.just("")
                case .failure(let error):
                    self.networkErrorSubject.onNext(error)
                    return Observable.error(error)
                }
            }
    }
}
