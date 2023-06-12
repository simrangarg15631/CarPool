//
//  BookRideData.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 03/06/23.
//

import Foundation

struct BookRideData: Codable {
    var passenger: Passenger
}

struct Passenger: Codable {
    var publishId: Int
    var seats: Int
    
    enum CodingKeys: String, CodingKey {
        case publishId = "publish_id"
        case seats
    }
}

struct BookRideResponse: Codable {
    var code: Int
    var error: String?
    var passenger: BookingDetails?
}

struct BookingDetails: Codable {
    var id: Int
    var userId: Int
    var publishId: Int
    var price: Double
    var seats: Int
    var status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case publishId = "publish_id"
        case price
        case seats
        case status
    }
}

extension BookRideResponse {
    static let reponse = BookRideResponse(code: 0, passenger: BookingDetails(
        id: 0, userId: 0, publishId: 0, price: 0, seats: 0, status: ""))
}
