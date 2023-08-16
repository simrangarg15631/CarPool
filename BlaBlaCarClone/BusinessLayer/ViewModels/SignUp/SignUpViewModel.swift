//
//  SignUpViewModel.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 10/05/23.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var email = String()
    @Published var password = String()
    @Published var confirmPassword = String()
    @Published var firstName = String()
    @Published var lastName = String()
    @Published var dateOfBirth = Date()
    @Published var gender = AppConstants.AppStrings.male
    @Published var phoneNumber = String()
    
    @Published var currentValue: Float = 1
    @Published var totalValue: Float = 3
    
    @Published var phoneMessage = String()
    @Published var errorMessage: APIError?
    @Published var userResponse: UserResponse?
    
    @Published var emailPrompt: Bool = false
    @Published var passPrompt: Bool = false
    @Published var confirmPrompt: Bool = false
    @Published var phonePrompt: Bool = false
    
    @Published var signUpActive: Bool = false
    @Published var newUser: Bool = false
    @Published var hasError: Bool = false
    @Published var isLoading: Bool = false
    
    var date = Calendar.current.date(byAdding: .year, value: -18, to: Date())
    var genderType = [AppConstants.AppStrings.male, AppConstants.AppStrings.female, AppConstants.AppStrings.notSay]
    var publisher: AnyCancellable?
    var validation = Validations()
   
    let network = NetworkManager.shared
    
    // MARK: - Methods
    
    /// calls Api to check if email already exists or not
    func checkEmail() {
        
        isLoading = true
        
        publisher = network.checkEmail(email: self.email)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                
                switch completion {
                    
                case .failure(let error):
                    // in case of faliure, api stops loading, has an error, which is assigned to errorMessage
                    print(error)
                    self?.isLoading = false
                    self?.hasError = true
                    self?.errorMessage = error as? APIError
                    
                case .finished:
                    // in case of success, api stops loading, no error
                    self?.isLoading = false
                    print("successful")
                    self?.hasError = false
                    self?.newUser.toggle()
                }
            }, receiveValue: { [weak self] data in
                self?.userResponse = data
            })
    }
    
    /// calls api to sign up user
    func signUp() {
        
        isLoading = true
        
        publisher = network.signUpLogIn(type: AppConstants.ButtonLabels.signUp, data: makeCredentials())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                    self.isLoading = false
                    self.hasError = true
                    self.errorMessage = error as? APIError
                    
                case .finished:
                    print("signup")
                    self.isLoading = false
                    self.hasError = false
                    self.signUpActive.toggle()
                }
            } receiveValue: { [weak self] data in
                self?.userResponse = data
            }
    }
    
    /// makes credentials in correct format to send in api body
    func makeCredentials() -> UserData {
        
        let userDetails = UserDetails(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
            dob: DateFormatterUtil.shared.formatDate(date: dateOfBirth),
            title: gender,
            phoneNumber: Int(phoneNumber)
        )
        
        return UserData(user: userDetails)
    }
    
    /// To check if mail is valid and on that basis show message to user
    func validEmail() {
        if !email.isEmpty && !validation.isvalidEmail(email) {
            // not valid, show message
            emailPrompt = true
        } else {
            // valid, don't show message
            emailPrompt = false
        }
    }
    
    /// To check if password is valid and on that basis show message to user
    func validPassword() {
        if !password.isEmpty && !validation.isvalidPassword(password) {
            // not valid, show message
            passPrompt = true
        } else {
            // valid, don't show message
            passPrompt = false
        }
    }
    
    /// To check if confirmPassword matches with password and on that basis show message to user
    func confirmPass() {
        if !confirmPassword.isEmpty && confirmPassword != password {
            confirmPrompt = true
        } else {
            confirmPrompt = false
        }
    }
    
    /// To check if phone number is valid or not
    func validPhone() {
        
        if Int(phoneNumber) == nil {
            // phoneNumber does not contain digits
            // shows message to user
            phonePrompt = true
            phoneMessage = AppConstants.AppStrings.phoneInt
        } else if phoneNumber.count != 10 {
            // phoneNumber is not equal to 10 digits
            // shows message to user
            phonePrompt = true
            phoneMessage = AppConstants.AppStrings.phonePrompt
        } else {
            // valid, no message to user
            phonePrompt = false
        }
    }
    
    /// if email, password, confirmPassword are not valid, disable the button
    /// - Returns: Bool, if valid returns false, else true
    func disableButton() -> Bool {
        if !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty {
            if !emailPrompt && !passPrompt && confirmPassword == password {
                return false
            }
        }
        return true
    }
    
    ///  To check whether to disable Next button or not
    /// - Returns: Bool
    func disableNextBtn() -> Bool {
        if !firstName.isEmpty && !lastName.isEmpty {
            return false
        }
        return true
    }
    
    ///  To check whether to disable Next button or not
    /// - Returns: Bool
    func disableSignUpbtn() -> Bool {
        
        if !phoneNumber.isEmpty && !phonePrompt {
            return false
        }
        return true
    }
}
