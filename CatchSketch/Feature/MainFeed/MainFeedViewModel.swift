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
    }
    
    struct Output {
        let refreshResult: Observable<Result<PostResponse, Error>>
        let posts: Observable<[Post]>
        let nextCursor: Observable<String?>
    }
    
    func transform(input: Input) -> Output {
        let postList = PublishSubject<[Post]>()
        let nextCursor = PublishSubject<String?>()
        
        let refreshResult = input.viewWillAppearTrigger
            .flatMapLatest { _  in
                NetworkService.shared.viewPost(query: .post(.postView(productID: "CatchSketch_global", limit: "10")))
                    .asObservable()
            }
            .share()
        
        refreshResult
            .compactMap { result -> [Post]? in
                switch result {
                case .success(let response):
                    return response.data
                case .failure:
                    return nil
                }
            }
            .bind(to: postList)
            .disposed(by: disposeBag)
        
        refreshResult
            .compactMap { result -> String? in
                switch result {
                case .success(let response):
                    return response.next_cursor
                case .failure:
                    return nil
                }
            }
            .bind(to: nextCursor)
            .disposed(by: disposeBag)
        
        return Output(
            refreshResult: refreshResult,
            posts: postList.asObservable(),
            nextCursor: nextCursor.asObservable()
        )
    }
}

