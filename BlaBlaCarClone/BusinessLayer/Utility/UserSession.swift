//
//  UserSession.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 10/08/23.
//

import Foundation

class UserSession {
    
    static let shared = UserSession()
    private init() {}
    
    func isSessionValid() -> Bool {
        if UserDefaults.standard.string(forKey: "Authorization") != nil {
            return true
        } else {
            return false
        }
    }
    
    func createSession(token: String?) {
        UserDefaults.standard.set(token, forKey: "Authorization")
    }
    
    func deleteSession() {
        UserDefaults.standard.set(nil, forKey: "Authorization")
    }
    
    func sessionToken() -> String? {
        return UserDefaults.standard.string(forKey: "Authorization")
    }
    
}
