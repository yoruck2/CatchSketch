//
//  UserDefaultsManager.swift
//  CatchSketch
//
//  Created by dopamint on 8/15/24.
//

import Foundation

struct UserData: Codable {
    let userID: String
    let email: String
    let nickname: String
    let profileImage: String
}

class UserDefaultsManager {
    // TODO: propertyWrapper + generic 으로 리팩토링
    enum UserDefaultsKey: String {
        case access
        case refresh
        case userData
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
    
    var userData: UserData? {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaultsKey.userData.rawValue) else {
                return nil
            }
            return try? JSONDecoder().decode(UserData.self, from: data)
        }
        set {
            guard let newValue = newValue,
                  let data = try? JSONEncoder.encode(with: newValue) else {
                UserDefaults.standard.removeObject(forKey: UserDefaultsKey.userData.rawValue)
                return
            }
            UserDefaults.standard.set(data, forKey: UserDefaultsKey.userData.rawValue)
        }
    }
    
    func updateUserData(userID: String? = nil,
                        email: String? = nil,
                        nickname: String? = nil,
                        profileImage: String? = nil) {
        let currentData = userData ?? UserData(userID: "", email: "", nickname: "", profileImage: "")
        let updatedData = UserData(
            userID: userID ?? currentData.userID,
            email: email ?? currentData.email,
            nickname: nickname ?? currentData.nickname,
            profileImage: profileImage ?? currentData.profileImage)
        userData = updatedData
    }
    func clearUserData() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.userData.rawValue)
    }
}
