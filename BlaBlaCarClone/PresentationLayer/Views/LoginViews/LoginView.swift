//
//  LoginPage.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 12/05/23.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var onboardVm: OnboardingViewModel
    @StateObject var vm = LoginViewModel()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        
        VStack {
            
            InputFieldView(placeholder: AppConstants.AppStrings.email,
                           keyBoardType: .emailAddress,
                           textFieldValue: $vm.email)
                .padding(.top, 20)
            
            // Password
            InputFieldView(placeholder: AppConstants.AppStrings.password,
                           isSecured: true,
                           textFieldValue: $vm.password)
                .padding(.top, 20)
            
            HStack {
                
                Spacer()
                
                Button {
                    vm.presenSheet.toggle()
                } label: {
                    Text(AppConstants.ButtonLabels.forgotPassword)
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.red)
                }
            }
            .padding(.top, 8)
            
            Spacer()
            
            if vm.isLoading {
                ProgressView()
                    .padding(.bottom, 20)
            }
            // Login button
            Button {
                vm.logIn()
            } label: {
                ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.logIn)
                    .cornerRadius(18)
            }
            .opacity(vm.disableButton() ? 0.5 : 1)
            .disabled(vm.disableButton())
            
            // SignUpButton
            HStack {
                Spacer()
                Text(AppConstants.AppStrings.notMember)
                
                // If coming from SignUp View
                if onboardVm.fromSignUpView {
                    Button {
                        // Pop to SignUp View
                        self.mode.wrappedValue.dismiss()
                    } label: {
                        Text(AppConstants.ButtonLabels.signUp)
                            .foregroundColor(Color.accentColor)
                    }
                }
                // If Coming from onboarding view
                else {
                    NavigationLink(destination: {
                        // Navigate to signUp view
                        SignUpView(onboardVm: onboardVm)
                    }, label: {
                        Text(AppConstants.ButtonLabels.signUp)
                            .foregroundColor(Color.accentColor)
                    })
                }
                
                Spacer()
            }
            .padding(.top, 20)
            .font(.headline)
                
        }
        .padding()
        .navigationTitle(AppConstants.AppStrings.login)
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
        .navigationDestination(isPresented: $vm.logInActive, destination: {
            TabBarView()
        })
        // Show alert if there is error
        .alert("", isPresented: $vm.hasError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}
        } message: {
            if let error = vm.errorMessage {
                Text(error.localizedDescription)
                    .font(.headline)
            }
        }
        .fullScreenCover(isPresented: $vm.presenSheet) {
            EnterEmailView()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginView(onboardVm: OnboardingViewModel())
        }
    }
}
