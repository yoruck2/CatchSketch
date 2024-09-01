//
//  MainFeedViewModel.swift
//  CatchSketch
//
//  Created by dopamint on 8/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MainFeedViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        let postSelected: ControlEvent<PostResponse.Post>
    }
    
    struct Output {
        let refreshResult: Observable<Result<PostResponse, Error>>
        let posts: Observable<[PostResponse.Post]>
        let modelSelected: Observable<SketchQuizViewController>
        let nextCursor: Observable<String?>
    }
    
    func transform(input: Input) -> Output {
        let postList = PublishSubject<[PostResponse.Post]>()
        let nextVC = PublishSubject<SketchQuizViewController>()
        let nextCursor = PublishSubject<String?>()
        
        let refreshResult = input.viewWillAppearTrigger
            .flatMapLatest { _  in
                NetworkService.shared.viewPost(query: .post(.postView(productID: "CatchSketch_global", 
                                                                      limit: "10")))
                    .asObservable()
            }
            .share()
        
        refreshResult
            .compactMap { result -> [PostResponse.Post]? in
                switch result {
                case .success(let response):
                    return response.data
                case .failure:
                    return nil
                }
            }
            .bind(to: postList)
            .disposed(by: disposeBag)
        
//        refreshResult
//            .compactMap { result -> String? in
//                switch result {
//                case .success(let response):
//                    return response.next_cursor
//                case .failure:
//                    return nil
//                }
//            }
//            .bind(to: nextCursor)
//            .disposed(by: disposeBag)
        
        input.postSelected
            .subscribe(with: self, onNext: { owner, post in
                nextVC.onNext(SketchQuizViewController(data: post))
            })
            .disposed(by: disposeBag)
        
        return Output(
            refreshResult: refreshResult,
            posts: postList.asObservable(), 
            modelSelected: nextVC,
            nextCursor: nextCursor.asObservable()
        )
    }
}

