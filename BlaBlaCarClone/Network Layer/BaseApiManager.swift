//
//  BaseApiManager.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 31/05/23.
//

import Foundation
import Combine

class BaseApiManager {
    
    var serviceHelper = ServiceHelper.shared
    static let shared = BaseApiManager()
    private init() {}
    
    func get<T: Codable>(url: String) -> AnyPublisher<T, Error> {
        
        guard let url = URL(string: url) else {
            print("error creating URL")
            return Fail(error: APIError.badURL)
                .eraseToAnyPublisher()
        }
        
        return serviceHelper.session(url: url,
                                     method: .get,
                                     body: nil,
                                     value: "application/json",
                                     headerField: "Content-Type")
    }
    
    func post<T: Codable, U: Codable>(url: String, data: U) -> AnyPublisher<T, Error> {
        
        guard let url = URL(string: url) else {
            print("error creating URL")
            return Fail(error: APIError.badURL)
                .eraseToAnyPublisher()
        }
        
        guard let jsonData = try? JSONEncoder().encode(data) else {
            print("error trying to convert model to jsonData")
            return Fail(error: APIError.parsing)
                .eraseToAnyPublisher()
        }
        
        return serviceHelper.session(url: url,
                                     method: .post,
                                     body: jsonData,
                                     value: "application/json",
                                     headerField: "Content-Type")
    }
    
    func put<T: Codable, U: Codable>(url: String, data: U) -> AnyPublisher<T, Error> {
        
        guard let url = URL(string: url) else {
            print("error creating URL")
            return Fail(error: APIError.badURL)
                .eraseToAnyPublisher()
        }
        
        guard let jsonData = try? JSONEncoder().encode(data) else {
            print("error trying to convert model to jsonData")
            return Fail(error: APIError.parsing)
                .eraseToAnyPublisher()
        }
        
        return serviceHelper.session(url: url,
                                     method: .put,
                                     body: jsonData,
                                     value: "application/json",
                                     headerField: "Content-Type")
    }
    
    func delete<T: Codable>(url: String, authToken: String?) -> AnyPublisher<T, Error> {
        
        guard let url = URL(string: url) else {
            print("error creating URL")
            return Fail(error: APIError.badURL)
                .eraseToAnyPublisher()
        }
        
        return serviceHelper.session(url: url,
                                     method: .delete,
                                     body: nil,
                                     value: authToken,
                                     headerField: "Authorization")
    }
    
}
