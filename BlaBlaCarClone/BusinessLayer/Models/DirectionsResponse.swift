//
//  DirectionsResponse.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 01/06/23.
//

import Foundation

struct DirectionsResponse: Codable {
    var routes: [Routes]?
}

struct Routes: Codable {
    var legs: [Legs]
    var overviewPolyline: Points
    
    enum CodingKeys: String, CodingKey {
        case legs
        case overviewPolyline = "overview_polyline"
    }
}

struct Legs: Codable {
    var distance: DistDurDetails
    var duration: DistDurDetails
}

struct DistDurDetails: Codable {
    var value: Int?
    var text: String
    
}

struct Points: Codable {
    var points: String
}
