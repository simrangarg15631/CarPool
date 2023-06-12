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
        
        var url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.checkEmailEndPoint
        url += "?\(AppConstants.ApiKeys.email)=\(email)"
        
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
                    UserDefaults.standard.set(self.authToken, forKey: "Authorization")
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
        
        return baseApiManager.handleResponse(url: url, method: RequestMethods.post.rawValue, data: phone, code: 401)
    }
    
    func verifyPhone(data: UserDetails) -> AnyPublisher<UserResponse, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.verifyPhone
        
        return baseApiManager.handleResponse(url: url, method: RequestMethods.post.rawValue, data: data, code: 401)
    }
    
    func getUserInfo() -> AnyPublisher<UserResponse, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.users
        
        return baseApiManager.get(url: url)
    }
    
    func getUserInfoById(id: Int) -> AnyPublisher<UserInfoResponse, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.users + "/\(id)"
        
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
        
        let boundary = NSUUID().uuidString
        let dataBody = baseApiManager.createDataBody(image: image, boundary: boundary)
        
//        return serviceHelper.session(url: url,
//                                     method: .put,
//                                     body: dataBody,
//                                     value: "multipart/form-data; boundary=\(boundary)",
//                                     headerField: "Content-Type")
        
        var request = URLRequest(url: url)
        request.httpMethod = RequestMethods.put.rawValue
        request.setValue(self.authToken, forHTTPHeaderField: "Authorization")
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
        
        return baseApiManager.handleResponse(url: url, method: RequestMethods.patch.rawValue, data: data, code: 422)
    }
    
    func signOut() -> AnyPublisher<Response, Error> {
       
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.signOut
        
        return baseApiManager.delete(url: url, authToken: authToken)
    }
    
    func deleteAccount() -> AnyPublisher<UserResponse, Error> {
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.users
        return baseApiManager.delete(url: url, authToken: authToken)
    }
    
    func getRoute(originLat: String, originLon: String,
                  destLat: String, destLon: String) -> AnyPublisher<DirectionsResponse, Error> {
        
        let url = AppConstants.DirectionsApi.baseUrl +
        "?destination=\(destLat),\(destLon)&origin=\(originLat),\(originLon)&key=\(AppConstants.DirectionsApi.ApiKey)"
        
        return baseApiManager.get(url: url)
    }
    
    func publishRide(data: PublishRideData) -> AnyPublisher<PublishRideResponse, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.publish
        
        return baseApiManager.post(url: url, data: data)
    }
    
    func search(data: SearchRide) -> AnyPublisher<SearchRideResponse, Error> {
        
        var url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.search
        
        url += "?\(AppConstants.ApiKeys.sourceLon)=\(data.sourceLon)"
        url += "&\(AppConstants.ApiKeys.sourceLat)=\(data.sourceLat)"
        url += "&\(AppConstants.ApiKeys.destLon)=\(data.destLon)"
        url += "&\(AppConstants.ApiKeys.destLat)=\(data.destLat)"
        url += "&\(AppConstants.ApiKeys.passCount)=\(data.passCount)"
        url += "&\(AppConstants.ApiKeys.date)=\(data.date)"
        url += "&\(AppConstants.ApiKeys.orderBy)=\(data.orderBy)"
        
        return baseApiManager.get(url: url)
        
    }
    
    func bookRide(data: BookRideData) -> AnyPublisher<BookRideResponse, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.bookRide
        
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
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.forgotPass
        
        return baseApiManager.post(url: url, data: data)
    }
    
    func verifyOtp(data: UserDetails) -> AnyPublisher<Status, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.verifyOtp
        return baseApiManager.post(url: url, data: data)
    }
    
    func resetPassword(data: ChangePassword) -> AnyPublisher<Status, Error> {
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.passwordReset
        
        return baseApiManager.post(url: url, data: data)
    }
    
    func getAllBookedRides() -> AnyPublisher<BookedRides, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.bookedRides
        
        return baseApiManager.get(url: url)
    }
    
    func getAllPublishedRides() -> AnyPublisher<PublishedRides, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.publish
        return baseApiManager.get(url: url)
    }
    
    func cancelBooking(data: CancelBookingModel) -> AnyPublisher<Status, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.cancelBooking
        return baseApiManager.post(url: url, data: data)
    }
    
    func cancelPublish(data: CancelBookingModel) -> AnyPublisher<Status, Error> {
        
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.cancelPublish
        return baseApiManager.post(url: url, data: data)
    }
    
    func getPassengersInfo(publishId: Int) -> AnyPublisher<RidePassenger, Error> {
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.publish + "/\(publishId)"
        return baseApiManager.get(url: url)
    }
    
    func updatePublishedRide(publishId: Int, data: UpdateRideData) -> AnyPublisher<PublishDetails, Error> {
        let url = AppConstants.ApiUrls.baseUrl + AppConstants.ApiUrls.publish + "/\(publishId)"
        return baseApiManager.put(url: url, data: data)
    }
}
