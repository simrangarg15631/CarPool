//
//  NetworkManager.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 12/05/23.
//

import Foundation
import Combine

class NetworkManager {
    
    static let shared = NetworkManager()
    var serviceHelper = ServiceHelper.shared
    var baseApiManager = BaseApiManager.shared
    var authToken: String?
    
    private init() {}
    
    /// To verify if email already exists during signUp process
    /// - Parameter email: String, emil address enteres by user
    /// - Returns: If success, returns userResponse? ( no response at success ), if failure returns Error
    func checkEmail(email: String) -> AnyPublisher<UserResponse?, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.checkEmailEndPoint + email
        
        guard let url = URL(string: url) else {
            print("error creating url")
            return Fail(error: APIError.badURL)
                .eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = RequestMethods.get.rawValue
        
        return URLSession.shared.dataTaskPublisher(for: request)
        // handle URL errors (most likely not able to connect to the server)
            .mapError { error -> Error in
                return APIError.serverError(error)
            }
        // handle all other errors
            .tryMap { (data, response) in
                print("Recieved response from server, now checking status code")
                
                guard let urlResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                switch urlResponse.statusCode {
                case 200..<300:
                    print("Ok")
                case 422:
                    let jsonObject = try JSONDecoder().decode(UserResponse.self, from: data)
                    throw APIError.validationError(jsonObject.status.error ?? "Error")
                default:
                    throw APIError.badResponse(urlResponse.statusCode)
                }
                return nil
            }
            .eraseToAnyPublisher()
    }
    
    func signUpLogIn(type: String, data: UserData) -> AnyPublisher<UserResponse, Error> {
        
        var url = AppConstants.ApiUrls.baseUrl
        
        if type == AppConstants.ButtonLabels.signUp {
            url += AppConstants.ApiUrls.users
        } else if type == AppConstants.ButtonLabels.logIn {
            url += AppConstants.ApiUrls.logInEndPoint
        }
        
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
        request.httpMethod = RequestMethods.post.rawValue
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
                
                if (200..<300) ~= urlResponse.statusCode {
                    self.authToken = urlResponse.value(forHTTPHeaderField: "Authorization")
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
                case 401:
                    throw APIError.validationError(jsonObject.status.error ?? "Error")
                default:
                    throw APIError.badResponse(jsonObject.status.code)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func sendOTP(phone: UserDetails) -> AnyPublisher<UserResponse, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.sendOTP
        
        guard let url = URL(string: url) else {
            print("error creating URL")
            return Fail(error: APIError.badURL)
                .eraseToAnyPublisher()
        }
        
        guard let jsonData = try? JSONEncoder().encode(phone) else {
            print("error trying to convert model to jsonData")
            return Fail(error: APIError.parsing)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = RequestMethods.post.rawValue
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
                case 401:
                    throw APIError.validationError(jsonObject.status.error ?? "Error")
                default:
                    throw APIError.badResponse(jsonObject.status.code)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func verifyPhone(data: UserDetails) -> AnyPublisher<UserResponse, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.sendOTP
        
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
        request.httpMethod = RequestMethods.post.rawValue
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
                case 401:
                    throw APIError.validationError(jsonObject.status.error ?? "Error")
                default:
                    throw APIError.badResponse(jsonObject.status.code)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getUserInfo() -> AnyPublisher<UserResponse, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.users
        
        return baseApiManager.get(url: url)
    }
    
    func editUserInfo(data: UserData) -> AnyPublisher<UserResponse, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.users
        
        return baseApiManager.put(url: url, data: data)
    }
    
    func addImage(image: Data) -> AnyPublisher<UserResponse, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.addImage
        
        guard let url = URL(string: url) else {
            print("error creating URL")
            return Fail(error: APIError.badURL)
                .eraseToAnyPublisher()
        }
        
        let boundary = "Boundary-\(NSUUID().uuidString)"
        let dataBody = createDataBody(image: image, boundary: boundary)
        
        return serviceHelper.session(url: url,
                                     method: .put,
                                     body: dataBody,
                                     value: "multipart/form-data; boundary=\(boundary)",
                                     headerField: "Content-Type")
    }
    
    func createDataBody(image: Data?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let media = image {
            body.append("--\(boundary + lineBreak)".data(using: .utf8) ?? Data())
            body.append("""
Content-Disposition: form-data; name=\"\(AppConstants.ApiKeys.image)\"; filename=\"imagefile.jpeg\"\(lineBreak)
""".data(using: .utf8) ?? Data())
            body.append("Content-Type: \(media) \"image/jpeg\"\(lineBreak + lineBreak)".data(using: .utf8) ?? Data())
            body.append(media)
            body.append(lineBreak.data(using: .utf8) ?? Data())
        }
        
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8) ?? Data())
        
        return body
    }
    
    func addVehicle(data: VehicleData) -> AnyPublisher<VehicleRes, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.vehicles
        
        return baseApiManager.post(url: url, data: data)
        
    }
    
    func getVehicle() -> AnyPublisher<VehicleStatus, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.vehicles
        
        return baseApiManager.get(url: url)
    }
    
    func editVehicle(vehicleId: Int, data: VehicleData) -> AnyPublisher<VehicleRes, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.vehicles + "/\(vehicleId)"
        
        return baseApiManager.put(url: url, data: data)
    }
    
    func deleteVehicle(vehicleId: Int) -> AnyPublisher<UserResponse, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.vehicles + "/\(vehicleId)"
        
        return baseApiManager.delete(url: url, authToken: authToken)
    }
    
    func changePassword(data: ChangePassword) -> AnyPublisher<UserResponse, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.updatePassword
        
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
        request.httpMethod = RequestMethods.patch.rawValue
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
                case 422:
                    throw APIError.validationError(jsonObject.status.error ?? "Error")
                default:
                    throw APIError.badResponse(jsonObject.status.code)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<[String: String], Error> {
       
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.signOut
        
        return baseApiManager.delete(url: url, authToken: authToken)
    }
    
//    func searchRides() -> AnyPublisher<
    func getRoute(originLat: String, originLon: String, destLat: String, destLon: String) -> AnyPublisher<String, Error> {
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?destination=\(destLat),\(destLon)&origin=\(originLat),\(originLon)&key=AIzaSyDUzn63K64-sXadyIwRJExCfMaicagwGq4"
        
        guard let url = URL(string: url) else {
            print("error creating url")
            return Fail(error: APIError.badURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
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
                    throw APIError.badResponse(urlResponse.statusCode)
                }
                return (data, urlResponse)
            }
        
            .map(\.data)
            .tryMap { data in
                do {
                    let decoder = JSONDecoder()
                    let jsonObject = try decoder.decode(DirectionsResponse.self, from: data)
                    print(jsonObject)
                    return jsonObject.routes[0].overview_polyline.points
                    
                } catch {
                    throw APIError.parsing
                }
            }
            .eraseToAnyPublisher()
    }
}
