//
//  RidePassenger.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 08/06/23.
//

import Foundation

struct RidePassenger: Codable {
    var code: Int
    var data: PublishDetails
    var passengers: [PassengerData]
}

struct PassengerData: Codable {
    var userId: Int
    var firstName: String
    var lastName: String
    var dob: String
    var phoneNumber: String?
    var phoneVerified: Bool?
    var image: URL?
    var averageRating: Double?
    var bio: String?
    var seats: Int
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case dob
        case phoneNumber = "phone_number"
        case phoneVerified = "phone_verified"
        case image
        case averageRating = "average_rating"
        case bio
        case seats
    }
}
