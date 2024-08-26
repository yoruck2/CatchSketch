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
    let items = BehaviorRelay<[String]>(value: [])
    
    init() {
        let dummyData = (1...20).map { "Item \($0)" }
        items.accept(dummyData)
    }
    
    struct Input {
        let viewDidLoadTrigger: Observable<Bool>
    }
    
    struct Output {
        let refreshResult: Observable<Result<PostResponse, Error>>
    }
    
    func transform(input: Input) -> Output {
        // Test
        let result = input.viewDidLoadTrigger
            .flatMap { _ in
                NetworkService.shared.viewPost(query: .post(.postView()))
            }
        return Output(refreshResult: result)
    }
}
