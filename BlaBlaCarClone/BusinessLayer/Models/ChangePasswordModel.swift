//
//  ChangePasswordModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 31/05/23.
//

import Foundation

struct ChangePassword: Codable {
    
    var currentPassword: String
    var password: String
    var confirmPassword: String
    
    enum CodingKeys: String, CodingKey {
        case currentPassword = "current_password"
        case password
        case confirmPassword = "password_confirmation"
    }
}
