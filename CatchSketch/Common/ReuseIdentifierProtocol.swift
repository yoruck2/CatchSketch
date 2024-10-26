//
//  ReuseIdentifierProtocol.swift
//  CatchSketch
//
//  Created by dopamint on 10/23/24.
//
import UIKit

protocol ReuseIdentifierProtocol: AnyObject {
    static var identifier: String { get }
}

extension UIView: ReuseIdentifierProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
