//
//  BaseViewModel.swift
//  CatchSketch
//
//  Created by dopamint on 8/18/24.
//

import Foundation

protocol BaseViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
