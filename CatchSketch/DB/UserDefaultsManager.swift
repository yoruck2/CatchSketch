//
//  UserDefaultsManager.swift
//  CatchSketch
//
//  Created by dopamint on 8/15/24.
//

import Foundation

class UserDefaultsManager {
    
    enum UserDefaultsKey: String {
        case access
        case refresh
    }

    static let shared = UserDefaultsManager()
    private init() {}
    
    var accessToken: String {
        
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKey.access.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKey.access.rawValue)
        }
    }
    var refreshToken: String {
        
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKey.refresh.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKey.refresh.rawValue)
        }
    }
}
