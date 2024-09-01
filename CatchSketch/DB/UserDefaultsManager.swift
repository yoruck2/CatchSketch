//
//  UserDefaultsManager.swift
//  CatchSketch
//
//  Created by dopamint on 8/15/24.
//

import Foundation

class UserDefaultsManager {
    // TODO: propertyWrapper + generic 으로 리팩토링
    enum UserDefaultsKey: String {
        case access
        case refresh
        case userID
        case email
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
    var userID: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKey.userID.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKey.userID.rawValue)
        }
    }
    var email: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKey.email.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKey.email.rawValue)
        }
    }    
}
