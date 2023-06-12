//
//  SwiftUIView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 11/05/23.
//

import SwiftUI

struct SignUpPhoneView: View {
    
    @ObservedObject var vm: SignUpViewModel
    @StateObject var phoneVm = SignUpPhoneViewModel()
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            ProgressBarView(currentValue: vm.totalValue, totalValue: vm.totalValue)
            
            Headingview(title: AppConstants.AppHeadings.enterPhone)
            
            InputFieldView(
                placeholder: AppConstants.AppStrings.phoneNumber,
                keyBoardType: .phonePad,
                textFieldValue: $vm.phoneNumber)
            
                .padding(.top, 25)
                .onChange(of: vm.phoneNumber, perform: {_ in
                    // as the value of phoneNumber changes, checks if the PhoneNumber is valid
                    vm.validPhone()
                })
            
            // show when phoneNumber is not valid
            if vm.phonePrompt {
                Text(vm.phoneMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(5)
            }
            
            Spacer()
            
            // Activity indicator to show api is loading
            if vm.isLoading {
                ProgressView()
                    .padding(.bottom, 20)
            }
            
            // SignUp Button
            Button {
                // calls api to signup
                // if success, it toggles the signUpActive value and calls sendOTP function
                // if error, it toggles the hasError value and shows alert
                vm.signUp()
            } label: {
                ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.signUp)
                    .cornerRadius(18)
            }
            // disable button if textfield is not filled correctly
            .opacity(vm.disableSignUpbtn() ? 0.5 : 1)
            .disabled(vm.disableSignUpbtn())
            
            .onChange(of: vm.signUpActive) { _ in
                // if successful signup, calls api to send otp to verify phoneNumber
                // if success, it toggles the isPresented value and navigates to next page
                // if error, it toggles the hasError value and shows alert
                phoneVm.sendOTP(phone: vm.phoneNumber)
            }
            
        }
        .padding()
        .navigationTitle(AppConstants.AppHeadings.finishSignUp)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $phoneVm.isPresented, destination: {
            // if otp is sent successfully, navigate to EnterOTPView
            EnterOTPView(phone: vm.phoneNumber)
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                // Back button
                ImageButton(image: AppConstants.AppImages.chevronleft) {
                    self.dismiss()
                }
                .font(.subheadline)
            }
        }
        // Show alert if there is error in signUp process
        .alert("", isPresented: $vm.hasError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}
        } message: {
            if let error = vm.errorMessage {
                Text(error.localizedDescription)
                    .font(.headline)
            }
        }
        // Show alert if there is error in sending otp
        .alert("", isPresented: $phoneVm.hasError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}
        } message: {
            if let error = phoneVm.errorMessage {
                Text(error.localizedDescription)
                    .font(.headline)
            }
        }
    }
}

struct SignUpPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpPhoneView(vm: SignUpViewModel())
        }
    }
}
