//
//  Enumerations.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 12/05/23.
//

import Foundation

enum RequestMethods: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum HomeScreenFieldTypes {
    case leavingFrom
    case goingTo
    case date
    case seats
}

enum VehicleRowType {
    case name
    case brand
    case country
    case color
    case type
    case number
    case model
}

enum APIError: LocalizedError {
    
    /// invalid URL
    case badURL
    
    /// not being able to connect to the server
    case serverError(Error)
    
    /// Received an invalid response, e.g. non-HTTP result
    case invalidResponse
    
    /// Server-side validation error
    case badResponse(Int)
    
    ///  Encoding Decoding error
    case parsing
    case validationError(String)
    
    var errorDescription: String? {
        switch self {
            
        case .badURL:
            return "invalid url"
            
        case .invalidResponse:
            return "invalid rsponse"
            
        case .badResponse(let statusCode):
            switch statusCode {
            case 500..<600:
                return "Not able to connect to the server. Please try again."
            case 404:
                return "Bad request"
            default:
                return "Something went wrong"
            }
        case .parsing:
            return "Parsing error"
            
        case .validationError(let error):
            return error
            
        case .serverError(let error):
            return error.localizedDescription 
        }
    }
}

enum TextFieldType {
    case otp1
    case otp2
    case otp3
    case otp4
    case button
}

enum ViewType {
    case add
    case edit
}

enum Options: String, CaseIterable {
    
    case itinerary = "Itinerary Details"
    case price = "Price"
    case seats = "Seats and options"
}
