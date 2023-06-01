//
//  DirectionsResponse.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 01/06/23.
//

import Foundation

struct DirectionsResponse: Codable {
    
    var routes: [Routes]
}

struct Routes: Codable {
    var overview_polyline: Points
}
struct Points: Codable {
    var points: String
}
