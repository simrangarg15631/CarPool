//
//  ChangePasswordView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 31/05/23.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @StateObject var changeVm = ChangePasswordViewModel()
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            InputFieldView(
                placeholder: AppConstants.AppStrings.currentPassword,
                isSecured: true,
                textFieldValue: $changeVm.currentPw)
            .padding(.top, 20)
            
            VStack(alignment: .leading) {
                
                InputFieldView(
                    placeholder: AppConstants.AppStrings.newPassword,
                    isSecured: true,
                    textFieldValue: $changeVm.newPw)
                .onChange(of: changeVm.newPw) { _ in
                    changeVm.validPassword()
                    changeVm.confirmPass()
                }
                
                if changeVm.passPrompt {
                    Text(AppConstants.AppStrings.weakPassword)
                        .font(.caption)
                        .foregroundColor(.red)
                    
                } else if !changeVm.passPrompt && !changeVm.newPw.isEmpty {
                    // show when password is strong
                    Text(AppConstants.AppStrings.strongPassword)
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            VStack(alignment: .leading) {
                InputFieldView(
                    placeholder: AppConstants.AppStrings.confirmPassword,
                    isSecured: true,
                    textFieldValue: $changeVm.confirmPw)
                .onChange(of: changeVm.confirmPw, perform: { _ in
                    changeVm.confirmPass()
                })
                
                if changeVm.confirmPrompt {
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
            
            if changeVm.showButton() {
                
                Button {
                    changeVm.changePassword(data: ChangePassword(
                        currentPassword: changeVm.currentPw,
                        password: changeVm.newPw,
                        confirmPassword: changeVm.confirmPw))
                } label: {
                    ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.changePassword)
                        .cornerRadius(12)
                }
            }

        }
        .onChange(of: changeVm.isSuccess, perform: { _ in
            NavigationUtil.popToRootView()
        })
        .padding()
        .navigationTitle(AppConstants.AppStrings.changePassword)
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
        .alert("", isPresented: $changeVm.hasError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}
        } message: {
            if let error = changeVm.errorMessage {
                Text(error.localizedDescription)
                    .font(.headline)
            }
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChangePasswordView()
        }
    }
}
