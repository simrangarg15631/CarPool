//
//  EnterEmailView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 26/05/23.
//

import SwiftUI

struct EnterEmailView: View {
    
    @StateObject var enterVm = EnterEmailViewModel()
    
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Headingview(title: AppConstants.AppHeadings.enterEmail)
            
            InputFieldView(placeholder: AppConstants.AppStrings.email,
                           keyBoardType: .emailAddress,
                           textFieldValue: $enterVm.email)
            .padding(.top)
            
            Spacer()
            
            if enterVm.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding(.bottom, 20)
                    Spacer()
                }
            }
            
            Button {
                enterVm.sendOtp(email: enterVm.email)
            } label: {
                ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.submit)
                    .cornerRadius(18)
            }
            .opacity(enterVm.email.isEmpty ? 0.5 : 1)
            .disabled(enterVm.email.isEmpty)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
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
        // Show alert if there is error
        .alert("", isPresented: $enterVm.hasError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}
        } message: {
            if let error = enterVm.errorMessage {
                Text(error.localizedDescription)
                    .font(.headline)
            }
        }
        .navigationDestination(isPresented: $enterVm.isSuccess) {
            OTPView(enterVm: enterVm, email: enterVm.email)
        }
    }
}

struct EnterEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EnterEmailView()
        }
    }
}
