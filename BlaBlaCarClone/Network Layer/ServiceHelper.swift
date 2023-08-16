//
//  ServiceHelper.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 12/05/23.
//

import Foundation
import Combine

class ServiceHelper {
    
    static let shared = ServiceHelper()
    private init() {}
    
    func session<T: Codable>(url: URL,
                             method: RequestMethods,
                             body: Data?,
                             token: String?) -> AnyPublisher<T, Error> {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.httpBody = body
        
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
                
                if !((200..<300) ~= urlResponse.statusCode) {
                    print()
                    throw APIError.badResponse(urlResponse.statusCode)
                }
                return (data, urlResponse)
            }
        
            .map(\.data)
            .tryMap { data in
                do {
                    let decoder = JSONDecoder()
                    let jsonObject = try decoder.decode(T.self, from: data)
                    print(jsonObject)
                    return jsonObject
                    
                } catch {
                    throw APIError.parsing
                }
            }
            .eraseToAnyPublisher()
    }
}
