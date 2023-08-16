//
//  UserInfoResponse.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 07/06/23.
//

import Foundation

struct UserInfoResponse: Codable {
    
    var code: Int?
    var user: DataResponse
    var imageUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case code
        case user
        case imageUrl = "image_url"
    }
}

extension UserInfoResponse {
    static let userInfo = UserInfoResponse(code: 0,
                                           user: DataResponse(id: 0,
                                                              email: "",
                                                              createdAt: "",
                                                              firstName: "Simran",
                                                              lastName: "Garg",
                                                              dob: "2001-08-24",
                                                              title: "",
                                                              bio: "hiii"))
}
