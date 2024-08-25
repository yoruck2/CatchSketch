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
        let postButtonTapped: ControlEvent<Void>
        let drawingUpdated: Observable<(PKDrawing, UIImage)>
        let correctAnswerText: ControlProperty<String>
        let quizImage: Observable<UIImage?>
    }
    
    struct Output {
        let currentDrawing: Driver<PKDrawing?>
        let currentImage: Driver<UIImage?>
        let showDrawViewController: Driver<PKDrawing?>
        let correctAnswerText: Observable<String>
        let isPostValid: Driver<Bool>
        let postResult: Observable<Result<PostResponse, Error>>
        let showAlert: Observable<String>
    }
    
    private let disposeBag = DisposeBag()
    private let showAlertRelay = PublishRelay<String>()
    
    func transform(input: Input) -> Output {
        let drawingRelay = BehaviorRelay<PKDrawing?>(value: nil)
        let imageRelay = BehaviorRelay<UIImage?>(value: nil)
        
        let nonEmptyCorrectAnswerText = input.correctAnswerText
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        let isPostValid = Observable.combineLatest(input.correctAnswerText, input.quizImage)
            .map { !$0.0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && $0.1 != nil }
            .asDriver(onErrorJustReturn: false)
        
        input.drawingUpdated
            .subscribe(onNext: { drawingRelay.accept($0.0); imageRelay.accept($0.1) })
            .disposed(by: disposeBag)
        
        let showDrawViewController = input.drawButtonTapped
            .withLatestFrom(drawingRelay)
            .asDriver(onErrorDriveWith: .empty())
        
        let postResult = input.postButtonTapped
            .withLatestFrom(Observable.combineLatest(input.quizImage, input.correctAnswerText))
            .flatMapLatest { [weak self] (image, answer) -> Observable<Result<PostResponse, Error>> in
                guard let self = self else { return .empty() }
                guard !answer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    self.showAlertRelay.accept("정답을 입력해 주세요")
                    return .empty()
                }
                guard let image = image, let imageData = image.jpegData(compressionQuality: 0.8) else {
                    self.showAlertRelay.accept("이미지가 없습니다")
                    return .empty()
                }
                
                return self.uploadImageAndCreatePost(imageData: imageData, answer: answer)
            }
            .share()
        
        postResult
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .success(let response):
                    if let postId = response.data.first?.post_id {
                        self?.showAlertRelay.accept("포스트가 성공적으로 생성되었습니다. ID: \(postId)")
                    }
                case .failure(let error):
                    self?.showAlertRelay.accept("포스트 생성에 실패했습니다: \(error.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            currentDrawing: drawingRelay.asDriver(),
            currentImage: imageRelay.asDriver(),
            showDrawViewController: showDrawViewController,
            correctAnswerText: nonEmptyCorrectAnswerText,
            isPostValid: isPostValid,
            postResult: postResult,
            showAlert: showAlertRelay.asObservable()
        )
    }
    
    private func uploadImageAndCreatePost(imageData: Data, answer: String) -> Observable<Result<PostResponse, Error>> {
        let imageUpload = ImageUpload(files: [imageData])
        // 이미지 업로드
        return NetworkService.shared.request(api: .post(.uploadImage(files: imageData)))
            .asObservable()
            .flatMap { (result: Result<ImageUploadResponse, Error>) -> Observable<Result<PostResponse, Error>> in
                switch result {
                case .success(let response):
                    guard let imagePath = response.files.first else {
                        return .just(.failure(NSError(domain: "ImageUploadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "업로드된 이미지 경로가 없습니다"])))
                    }
                    let postRequest = PostRequest(product_id: "CatchSketch_global", content: answer, files: [imagePath])
                    return NetworkService.shared.post(query: .post(.create(post: postRequest))).asObservable()
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
    }
}
