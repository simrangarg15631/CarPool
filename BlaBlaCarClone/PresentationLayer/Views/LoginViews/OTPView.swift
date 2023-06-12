//
//  OTPView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 05/06/23.
//

import SwiftUI

struct OTPView: View {
    
    @StateObject var otpVm = OTPViewModel()
    @Environment (\.dismiss) var dismiss
    @FocusState var isFocused: TextFieldType?
    var email = String()
    @State private var otp1Emp: Bool = false
    @State private var otp2Emp: Bool = false
    @State private var otp3Emp: Bool = false
    @State private var otp4Emp: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Headingview(title: AppConstants.AppHeadings.enterOtp)
            
            HStack {
                Spacer()
                
                OtpFieldView(value: $otpVm.otp1, isEmpty: $otp1Emp)
                    .focused($isFocused, equals: .otp1)
                    .onChange(of: otpVm.otp1, perform: { _ in
                        if otpVm.otp1.count == 1 {
                            isFocused = .otp2
                        }
                    })
                
                OtpFieldView(value: $otpVm.otp2, isEmpty: $otp2Emp)
                    .focused($isFocused, equals: .otp2)
                    .onChange(of: otpVm.otp2, perform: { _ in
                        if otpVm.otp2.count == 1 {
                            isFocused = .otp3
                        }
                    })
                    .onChange(of: otp2Emp, perform: { _ in
                        isFocused = .otp1

                    })
                OtpFieldView(value: $otpVm.otp3, isEmpty: $otp3Emp)
                    .focused($isFocused, equals: .otp3)
                    .onChange(of: otpVm.otp3, perform: { _ in
                        if otpVm.otp3.count == 1 {
                            isFocused = .otp4
                        }
                    })
                    .onChange(of: otp3Emp, perform: { _ in
                        isFocused = .otp2

                    })
                
                OtpFieldView(value: $otpVm.otp4, isEmpty: $otp4Emp)
                .focused($isFocused, equals: .otp4)
                .onChange(of: otpVm.otp4, perform: { _ in
                    if otpVm.otp4.count == 1 {
                        isFocused = .button
                    }
                })
                .onChange(of: otp4Emp, perform: { _ in
                    isFocused = .otp3

                })
                
                Spacer()
            }
            .padding(.top)
            
            Spacer()
            
            if otpVm.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding(.bottom, 20)
                    Spacer()
                }
            }
            
            Button {
                // phone verify
                otpVm.verifyOtp(email: email)
            } label: {
                ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.veify)
                    .cornerRadius(12)
            }

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
        .navigationDestination(isPresented: $otpVm.verified, destination: {
            ResetPasswordView(email: email)
        })
        // Show alert if there is error in signUp process
        .alert("", isPresented: $otpVm.hasError) {
            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}
        } message: {
            if let error = otpVm.errorMessage {
                Text(error.localizedDescription)
                    .font(.headline)
            }
        }
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OTPView()
        }
    }
}
