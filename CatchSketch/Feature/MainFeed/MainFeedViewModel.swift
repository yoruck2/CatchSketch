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
    
    let items = BehaviorRelay<[String]>(value: [])
    
    init() {
        // 더미 데이터 생성
        let dummyData = (1...20).map { "Item \($0)" }
        items.accept(dummyData)
    }
    struct Input {
        let viewDidLoadTrigger: PublishSubject<Void>
    }
    
    struct Output {
        let loginResult: Observable<Result<LogInResponse, Error>>
    }
    
    func transform(input: Input) -> Output {
        let result = input.viewDidLoadTrigger
            .map { query in
                NetworkService.shared.logIn(query: .post(.postView()))
            }
            .catch { error in
                //                    if (error as! APIError) == .expiredRefreshToken {
                //                        return .just(.failure(error as! APIError))
                //                    }
                return .just(.failure(error))
            }
            .share(replay: 1)
        
        return Output(loginResult: result)
    }
}
