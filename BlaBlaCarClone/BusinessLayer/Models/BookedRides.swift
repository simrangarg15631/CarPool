//
//  AllPublishResponse.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 07/06/23.
//

import Foundation

struct BookedRides: Codable {
    
    var code: Int
    var rides: [Rides]
}

struct Rides: Codable {
    var ride: PublishDetails
    var bookingId: Int
    var seat: Int
    var status: String
    
    enum CodingKeys: String, CodingKey {
        case ride
        case bookingId = "booking_id"
        case seat
        case status
    }
}

extension BookedRides {
    static let rides = BookedRides(code: 0, rides: [Rides(ride: PublishRideResponse.publishRideResponse.publish,
                                                          bookingId: 0,
                                                          seat: 1,
                                                          status: "cancel booking")])
}
