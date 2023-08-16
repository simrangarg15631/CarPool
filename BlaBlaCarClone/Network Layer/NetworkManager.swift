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
    
    private init() {}
    
    /// To verify if email already exists during signUp process
    /// - Parameter email: String, emil address enteres by user
    /// - Returns: If success, returns userResponse? ( no response at success ), if failure returns Error
    func checkEmail(email: String) -> AnyPublisher<UserResponse?, Error> {
        
        var url = ApiUrls.baseUrl + ApiUrls.checkEmailEndPoint
        url += "?\(ApiKeys.email)=\(email)"
        
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
        
        var url = ApiUrls.baseUrl
        
        if type == AppConstants.ButtonLabels.signUp {
            url += ApiUrls.users
        } else if type == AppConstants.ButtonLabels.logIn {
            url += ApiUrls.logInEndPoint
        }
        
        guard let url = URL(string: url) else {
            print("error creating URL")
            return Fail(error: APIError.badURL)
                .eraseToAnyPublisher()
        }
        print(data)
        guard let jsonData = try? JSONEncoder().encode(data) else {
            print("error trying to convert model to jsonData")
            return Fail(error: APIError.parsing)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = RequestMethods.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        print(jsonData)
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
                    UserSession.shared.createSession(token: urlResponse.value(forHTTPHeaderField: "Authorization"))
                }
                print(urlResponse)
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
        
        let url = ApiUrls.baseUrl + ApiUrls.sendOTP
        
        return baseApiManager.handleResponse(url: url, method: RequestMethods.post.rawValue, data: phone, code: 401, authToken: UserSession.shared.sessionToken())
    }
    
    func verifyPhone(data: UserDetails) -> AnyPublisher<UserResponse, Error> {
        
        let url = ApiUrls.baseUrl + ApiUrls.verifyPhone
        
        return baseApiManager.handleResponse(url: url, method: RequestMethods.post.rawValue, data: data, code: 401, authToken: UserSession.shared.sessionToken())
    }
    
    func getUserInfo() -> AnyPublisher<UserResponse, Error> {
        
        let url = ApiUrls.baseUrl + ApiUrls.users
        print(UserSession.shared.sessionToken())
        return baseApiManager.get(url: url, authToken: UserSession.shared.sessionToken())
    }
    
    func getUserInfoById(id: Int) -> AnyPublisher<UserInfoResponse, Error> {
        
        let url = ApiUrls.baseUrl + ApiUrls.users + "/\(id)"
        
        return baseApiManager.get(url: url, authToken: UserSession.shared.sessionToken())
    }
    
    func editUserInfo(data: UserData) -> AnyPublisher<UserResponse, Error> {
        
        let url = ApiUrls.baseUrl + ApiUrls.users
        
        return baseApiManager.put(url: url, data: data, authToken: UserSession.shared.sessionToken())
    }
    
    func addImage(image: Data) -> AnyPublisher<UserResponse, Error> {
        
        let url = ApiUrls.baseUrl + ApiUrls.addImage
        
        guard let url = URL(string: url) else {
            print("error creating URL")
            return Fail(error: APIError.badURL)
                .eraseToAnyPublisher()
        }
        
        let boundary = NSUUID().uuidString
        let dataBody = baseApiManager.createDataBody(image: image, boundary: boundary)
        
//        return serviceHelper.session(url: url,
//                                     method: .put,
//                                     body: dataBody,
//                                     value: "multipart/form-data; boundary=\(boundary)",
//                                     headerField: "Content-Type")
        
        var request = URLRequest(url: url)
        request.httpMethod = RequestMethods.put.rawValue
        request.setValue(UserSession.shared.sessionToken(), forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = dataBody
        
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
                print(urlResponse)
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
    
    func addVehicle(data: VehicleData) -> AnyPublisher<VehicleRes, Error> {
        
        let url = ApiUrls.baseUrl + ApiUrls.vehicles
        
        return baseApiManager.post(url: url, data: data, authToken: UserSession.shared.sessionToken())
        
    }
    
    func getVehicle() -> AnyPublisher<VehicleStatus, Error> {
        
        let url = ApiUrls.baseUrl + ApiUrls.vehicles
        
        return baseApiManager.get(url: url, authToken: UserSession.shared.sessionToken())
    }
    
    func editVehicle(vehicleId: Int, data: VehicleData) -> AnyPublisher<VehicleRes, Error> {
        
        let url = ApiUrls.baseUrl + ApiUrls.vehicles + "/\(vehicleId)"
        
        return baseApiManager.put(url: url, data: data, authToken: UserSession.shared.sessionToken())
    }
    
    func deleteVehicle(vehicleId: Int) -> AnyPublisher<UserResponse, Error> {
        
        let url = ApiUrls.baseUrl + ApiUrls.vehicles + "/\(vehicleId)"
        
        return baseApiManager.delete(url: url, authToken: UserSession.shared.sessionToken())
    }
    
    func changePassword(data: ChangePassword) -> AnyPublisher<UserResponse, Error> {
        
        let url = ApiUrls.baseUrl + ApiUrls.updatePassword
        
        return baseApiManager.handleResponse(url: url, method: RequestMethods.patch.rawValue, data: data, code: 422, authToken: UserSession.shared.sessionToken())
    }
    
    func signOut() -> AnyPublisher<Response, Error> {
       
        let url = ApiUrls.baseUrl + ApiUrls.signOut
        
        return baseApiManager.delete(url: url, authToken: UserSession.shared.sessionToken())
    }
    
    func deleteAccount() -> AnyPublisher<UserResponse, Error> {
        let url = ApiUrls.baseUrl + ApiUrls.users
        return baseApiManager.delete(url: url, authToken: UserSession.shared.sessionToken())
    }
    
    func getRoute(originLat: String, originLon: String,
                  destLat: String, destLon: String) -> AnyPublisher<DirectionsResponse, Error> {
        
        let url = DirectionsApi.baseUrl +
        "?destination=\(destLat),\(destLon)&origin=\(originLat),\(originLon)&key=\(DirectionsApi.ApiKey)"
        
        return baseApiManager.get(url: url, authToken: UserSession.shared.sessionToken())
    }
    
    func publishRide(data: PublishRideData) -> AnyPublisher<PublishRideResponse, Error> {
        
        let url = ApiUrls.baseUrl + ApiUrls.publish
        
        return baseApiManager.post(url: url, data: data, authToken: UserSession.shared.sessionToken())
    }
    
    func search(data: SearchRide) -> AnyPublisher<SearchRideResponse, Error> {
        
        var url = ApiUrls.baseUrl + ApiUrls.search
        
        url += "?\(ApiKeys.sourceLon)=\(data.sourceLon)"
        url += "&\(ApiKeys.sourceLat)=\(data.sourceLat)"
        url += "&\(ApiKeys.destLon)=\(data.destLon)"
        url += "&\(ApiKeys.destLat)=\(data.destLat)"
        url += "&\(ApiKeys.passCount)=\(data.passCount)"
        url += "&\(ApiKeys.date)=\(data.date)"
        url += "&\(ApiKeys.orderBy)=\(data.orderBy)"
        
        return baseApiManager.get(url: url, authToken: UserSession.shared.sessionToken())
        
    }
    
    func bookRide(data: BookRideData) -> AnyPublisher<BookRideResponse, Error> {
        
        let url = ApiUrls.baseUrl + ApiUrls.bookRide
        
        guard let url = URL(string: url) else {
            print("error creating URL")
            return Fail(error: APIError.badURL)
                .eraseToAnyPublisher()
        }
        print(data)
        guard let jsonData = try? JSONEncoder().encode(data) else {
            print("error trying to convert model to jsonData")
            return Fail(error: APIError.parsing)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = RequestMethods.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserSession.shared.sessionToken(), forHTTPHeaderField: "Authorization")
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
                    let jsonObject = try decoder.decode(BookRideResponse.self, from: data)
                    print(jsonObject)
                    switch jsonObject.code {
                    case 200..<300:
                        print("ok")
                        return jsonObject
                    case 422:
                        throw APIError.validationError(jsonObject.error ?? "Error")
                    default:
                        throw APIError.badResponse(jsonObject.code)
                    }
            }
            .eraseToAnyPublisher()
    }
    
    func forgotPassword(data: UserDetails) -> AnyPublisher<Status, Error> {
        
        let url = ApiUrls.baseUrl + ApiUrls.forgotPass
        
        return baseApiManager.post(url: url, data: data, authToken: UserSession.shared.sessionToken())
    }
    
    func verifyOtp(data: UserDetails) -> AnyPublisher<Status, Error> {
        
        let url = ApiUrls.baseUrl + ApiUrls.verifyOtp
        return baseApiManager.post(url: url, data: data, authToken: UserSession.shared.sessionToken())
    }
    
    func resetPassword(data: ChangePassword) -> AnyPublisher<Status, Error> {
        let url = ApiUrls.baseUrl + ApiUrls.passwordReset
        
        return baseApiManager.post(url: url, data: data, authToken: UserSession.shared.sessionToken())
    }
    
    func getAllBookedRides() -> AnyPublisher<BookedRides, Error> {
        
        let url = ApiUrls.baseUrl + ApiUrls.bookedRides
        
        return baseApiManager.get(url: url, authToken: UserSession.shared.sessionToken())
    }
    
    func getAllPublishedRides() -> AnyPublisher<PublishedRides, Error> {
        
        let url = ApiUrls.baseUrl + ApiUrls.publish
        return baseApiManager.get(url: url, authToken: UserSession.shared.sessionToken())
    }
    
    func cancelBooking(data: CancelBookingModel) -> AnyPublisher<Status, Error> {
        
        let url = ApiUrls.baseUrl + ApiUrls.cancelBooking
        return baseApiManager.post(url: url, data: data, authToken:UserSession.shared.sessionToken())
    }
    
    func cancelPublish(data: CancelBookingModel) -> AnyPublisher<Status, Error> {
        
        let url = ApiUrls.baseUrl + ApiUrls.cancelPublish
        return baseApiManager.post(url: url, data: data, authToken: UserSession.shared.sessionToken())
    }
    
    func getPassengersInfo(publishId: Int) -> AnyPublisher<RidePassenger, Error> {
        let url = ApiUrls.baseUrl + ApiUrls.publish + "/\(publishId)"
        return baseApiManager.get(url: url, authToken: UserSession.shared.sessionToken())
    }
    
    func updatePublishedRide(publishId: Int, data: UpdateRideData) -> AnyPublisher<PublishRideResponse, Error> {
        let url = ApiUrls.baseUrl + ApiUrls.publish + "/\(publishId)"
        return baseApiManager.put(url: url, data: data, authToken: UserSession.shared.sessionToken())
    }
}
