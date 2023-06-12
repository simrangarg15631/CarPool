//
//  ResetPasswordView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 05/06/23.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @StateObject var vm = ResetPasswordViewModel()
    @Environment (\.dismiss) var dismiss
    var email = String()
    
    var body: some View {
        
        VStack {
            
            VStack(alignment: .leading) {
                InputFieldView(
                    placeholder: AppConstants.AppStrings.password,
                    isSecured: true,
                    textFieldValue: $vm.newPassword)
                
                .padding(.top, 20)
                .onChange(of: vm.newPassword, perform: { _ in
                    vm.validPassword()
                    vm.confirmPass()
                })
                
                if vm.passPrompt {
                    // show when password is weak
                    Text(AppConstants.AppStrings.weakPassword)
                        .font(.caption)
                        .foregroundColor(.red)
                    
                } else if !vm.passPrompt && !vm.newPassword.isEmpty {
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
            }
            
            Text(AppConstants.AppStrings.infoMssg + AppConstants.AppStrings.infoMssg2)
                .font(.subheadline)
                .opacity(0.8)
                .padding(.top, 20)
            
            Spacer()
            
            if vm.isLoading {
                ProgressView()
                    .padding(.bottom, 20)
            }
            
            Button {
                vm.resetPassword(
                    data: ChangePassword(
                        email: email,
                        password: vm.newPassword,
                        confirmPassword: vm.confirmPassword))
            } label: {
                ButtonLabelView(buttonLabel: AppConstants.AppStrings.resetPassword)
                    .cornerRadius(12)
            }
            .opacity(vm.disableButton() ? 0.5 : 1)
            .disabled(vm.disableButton())
            .onChange(of: vm.isSuccess) { _ in
                if vm.isSuccess {
                    NavigationUtil.popToRootView()
                }
            }
        }
        .padding()
        .navigationTitle(AppConstants.AppStrings.resetPassword)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                // Back button
                ImageButton(image: AppConstants.AppImages.chevronleft) {
                    self.dismiss()
                }
                .font(.subheadline)
            }
        }
        // Show alert if there is error in updating profile
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

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ResetPasswordView()
        }
    }
}
