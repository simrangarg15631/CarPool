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
    
    func createDataBody(image: Data?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let media = image {
            body.append("--\(boundary + lineBreak)".data(using: .utf8) ?? Data())
            body.append("""
Content-Disposition: form-data; name=\"\(ApiKeys.image)\"; filename=\"imagefile.jpeg\"\(lineBreak)
""".data(using: .utf8) ?? Data())
            body.append("Content-Type: \(media) image/jpeg\(lineBreak + lineBreak)".data(using: .utf8) ?? Data())
            body.append(media)
            body.append(lineBreak.data(using: .utf8) ?? Data())
        }
        
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8) ?? Data())
        
        return body
    }
    
    func handleResponse<T: Codable>(url: String, method: String, data: T, code: Int) ->
    AnyPublisher<UserResponse, Error> {
        
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
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        return URLSession.shared.dataTaskPublisher(for: request)
        // handle URL errors (most likely not able to connect to the server)
            .mapError { error -> Error in
                return APIError.serverError(error)
            }
        // handle all other errors
            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
                print("Recieved response from server, now checking status code")
                
                guard let urlResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                return (data, urlResponse)
            }
        
            .map(\.data)
            .tryMap { data in
                let decoder = JSONDecoder()
                let jsonObject = try decoder.decode(UserResponse.self, from: data)
                print(jsonObject)
                switch jsonObject.status.code {
                case 200..<300:
                    print("ok")
                    return jsonObject
                case code:
                    throw APIError.validationError(jsonObject.status.error ?? "Error")
                default:
                    throw APIError.badResponse(jsonObject.status.code)
                }
            }
            .eraseToAnyPublisher()
    }
}
