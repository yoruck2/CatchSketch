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
        let refreshTrigger: Observable<Void>
        let postSelected: ControlEvent<PostResponse.Post>
        let prefetchingItem: ControlEvent<[IndexPath]>
        let didScroll: ControlEvent<Void>
    }
    
    struct Output {
        let refreshResult: Observable<Result<PostResponse, Error>>
        let posts: Observable<[PostResponse.Post]>
        let modelSelected: Observable<SketchQuizViewController>
        let nextCursor: Observable<String?>
        let isRefreshing: Observable<Bool>
    }
    
    private let postList = BehaviorRelay<[PostResponse.Post]>(value: [])
    private let nextCursor = BehaviorRelay<String?>(value: nil)
    private let isLoading = BehaviorRelay<Bool>(value: false)
    private let refreshTrigger = PublishSubject<Void>()
    
    func loadInitialData() {
        refreshTrigger.onNext(())
    }
    
    func refreshData() {
        refreshTrigger.onNext(())
    }
    func transform(input: Input) -> Output {
        let nextVC = PublishSubject<SketchQuizViewController>()
        
        let refreshResult = Observable.merge(refreshTrigger.asObservable(), input.refreshTrigger)
            .flatMapLatest { [weak self] _ -> Observable<Result<PostResponse, Error>> in
                guard let self = self else { return .empty() }
                return self.fetchPosts(isRefresh: true)
            }
            .share()
        
        refreshResult
            .compactMap { result in
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
            .compactMap { result in
                switch result {
                case .success(let response):
                    return response.next_cursor
                case .failure:
                    return nil
                }
            }
            .bind(to: nextCursor)
            .disposed(by: disposeBag)
        
        input.postSelected
            .subscribe { post in
                nextVC.onNext(SketchQuizViewController(data: post))
            }
            .disposed(by: disposeBag)
        
        input.prefetchingItem
            .filter { [weak self] indexPaths in
                guard let self = self, !self.isLoading.value, nextCursor.value != "0" else { return false }
                print(indexPaths)
                print(self.postList.value.count)
                return indexPaths.contains { $0.item >= self.postList.value.count - 5 }
            }
            .flatMapLatest { [weak self] _ -> Observable<Result<PostResponse, Error>> in
                guard let self else { return .empty() }
                return self.fetchPosts(isRefresh: false)
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        return Output(
            refreshResult: refreshResult,
            posts: postList.asObservable(),
            modelSelected: nextVC,
            nextCursor: nextCursor.asObservable(),
            isRefreshing: isLoading.asObservable()
        )
    }
    
    private func fetchPosts(isRefresh: Bool) -> Observable<Result<PostResponse, Error>> {
        isLoading.accept(true)
        
        let cursor = isRefresh ? nil : nextCursor.value
        
        return NetworkService.shared.viewPost(query: .post(.postView(productID: "CatchSketch_global",
                                                                     cursor: cursor,
                                                                     limit: "10")))
        .asObservable()
        .do(onNext: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                if isRefresh {
                    self.postList.accept(response.data)
                } else {
                    let updatedPosts = self.postList.value + response.data
                    self.postList.accept(updatedPosts)
                }
                self.nextCursor.accept(response.next_cursor)
            case .failure:
                break
            }
            self.isLoading.accept(false)
        })
    }
}
