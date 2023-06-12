//
//  SignUpView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 10/05/23.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject var vm = SignUpViewModel()
    @ObservedObject var onboardVm: OnboardingViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack {
            
            VStack(alignment: .leading) {
                
                InputFieldView(
                    placeholder: AppConstants.AppStrings.email,
                    keyBoardType: .emailAddress,
                    textFieldValue: $vm.email)
                
                .padding(.top, 20)
                .onChange(of: vm.email, perform: { _ in
                    // as the value of email changes, checks if the email is valid
                    vm.validEmail()
                })
                
                // show when email is not valid
                if vm.emailPrompt {
                    Text(AppConstants.AppStrings.emailMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                InputFieldView(
                    placeholder: AppConstants.AppStrings.password,
                    isSecured: true,
                    textFieldValue: $vm.password)
                
                .padding(.top, 20)
                .onChange(of: vm.password, perform: { _ in
                    // as the value of password changes, checks
                    // if the password is valid
                    vm.validPassword()
                    // and matches with confirm password
                    vm.confirmPass()
                })
                
                if vm.passPrompt {
                    // show when password is weak
                    Text(AppConstants.AppStrings.weakPassword)
                        .font(.caption)
                        .foregroundColor(.red)
                    
                } else if !vm.passPrompt && !vm.password.isEmpty {
                    // show when password is strong
                    Text(AppConstants.AppStrings.strongPassword)
                        .font(.caption)
                        .foregroundColor(.green)
                }
                
                InputFieldView(
                    placeholder: AppConstants.AppStrings.confirmPassword,
                    isSecured: true,
                    textFieldValue: $vm.confirmPassword)
                .padding(.top, 20)
                .onChange(of: vm.confirmPassword, perform: { _ in
                    vm.confirmPass()
                })
                
                // show when confirm password does not match with password
                if vm.confirmPrompt {
                    Text(AppConstants.AppStrings.confirmMssg)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                Text(AppConstants.AppStrings.infoMssg + AppConstants.AppStrings.infoMssg2)
                    .font(.subheadline)
                    .opacity(0.8)
                    .padding(.top, 20)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            // when Api is loading, show Activity Indicator
            if vm.isLoading {
                ProgressView()
                    .padding(.bottom, 20)
            }
            
            // Continue button
            Button {
                // Calls Api to check if email already exists
                // if success, it toggles the newUser value and navigates to next page
                // if error, it toggles the hasError value and shows alert
                vm.checkEmail()
            } label: {
                ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.contnue)
                    .cornerRadius(18)
            }
            // disable the button when all textfields are not correctly filled
            .opacity(vm.disableButton() ? 0.5 : 1)
            .disabled(vm.disableButton())
            
            // LogInButton
            HStack {
                
                Text(AppConstants.AppStrings.alreadyMember)
                
                // If coming from onboarding View
                if onboardVm.fromSignUpView {
                    NavigationLink(destination: {
                        // Navigate to login view
                        LoginView(onboardVm: onboardVm)
                    }, label: {
                        Text(AppConstants.ButtonLabels.logIn)
                            .foregroundColor(Color.accentColor)
                    })
                }
                // If coming from Login view
                else {
                    Button(action: {
                        // pop to Login view
                        self.mode.wrappedValue.dismiss()
                    }, label: {
                        Text(AppConstants.ButtonLabels.logIn)
                            .foregroundColor(Color.accentColor)
                    })
                }
                
            }
            .padding(.top, 20)
            .font(.headline)
        }
        .padding()
        .navigationTitle(AppConstants.ButtonLabels.signUp)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                // Back button
                ImageButton(image: AppConstants.AppImages.chevronleft) {
                    self.mode.wrappedValue.dismiss()
                }
                .font(.subheadline)
            }
        }
        .navigationDestination(isPresented: $vm.newUser) {
            // Navigate to SignUpDetailsView if user is new
            SignUpNameView(vm: vm)
        }
        // Show alert if there is an error
        .alert("", isPresented: $vm.hasError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}
        } message: {
            if let error = vm.errorMessage {
                Text(error.localizedDescription)
                    .font(.headline)
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpView(onboardVm: OnboardingViewModel())
        }
    }
}
