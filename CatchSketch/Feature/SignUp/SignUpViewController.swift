//
//  SignUpViewController.swift
//  CatchSketch
//
//  Created by dopamint on 8/18/24.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    let disposeBag = DisposeBag()
    
//    let loginQuery = AuthQuery.LogIn(email: "yoruck2", password: "1234")

    override func viewDidLoad() {
        super.viewDidLoad()
//        NetworkService.shared.requestC(api: .auth(.login(query: loginQuery)),
//                                              model: LogInResponse.self)
        
//        let aa = NetworkService.shared.request(api: .auth(.login(query: loginQuery)),
//                                      model: LogInResponse.self)
//            .catch { error in
////                return Single.just(.failure(.responseValidationFailed(reason: .customValidationFailed(error: error))))
//                return Single.never()
//            }
//        aa.subscribe(with: self) { owner , ss in
//            switch ss {
//            case .success(let value):
//                dump(value)
//            case .failure(let error):
//                print(error.responseCode)
//            }
//        }.disposed(by: disposeBag)
    }
}
