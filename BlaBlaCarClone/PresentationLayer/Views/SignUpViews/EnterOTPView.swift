//
//  EnterOTPView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 26/05/23.
//

import SwiftUI

struct EnterOTPView: View {
    
    @StateObject var otpVm = EnterOTPViewModel()
    @Environment (\.dismiss) var dismiss
    @FocusState var isFocused: TextFieldType?
    
    var phone = String()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Headingview(title: AppConstants.AppHeadings.enterOTP)
            
            HStack {
                Spacer()
                
//                OtpFieldView(value: $otpVm.otp1, )
//                    .focused($isFocused, equals: .otp1)
//                    .onChange(of: otpVm.otp1, perform: { _ in
//                        if otpVm.otp1.count == 1 {
//                            isFocused = .otp2
//                        }
//                    })
//                
//                OtpFieldView(value: $otpVm.otp2)
//                    .focused($isFocused, equals: .otp2)
//                    .onChange(of: otpVm.otp2, perform: { _ in
//                        if otpVm.otp2.count == 1 {
//                            isFocused = .otp3
//                        }
//                    })
//                
//                OtpFieldView(value: $otpVm.otp3)
//                    .focused($isFocused, equals: .otp3)
//                    .onChange(of: otpVm.otp3, perform: { _ in
//                        if otpVm.otp3.count == 1 {
//                            isFocused = .otp4
//                        }
//                    })
//                
//                OtpFieldView(value: $otpVm.otp4)
//                .focused($isFocused, equals: .otp4)
//                .onChange(of: otpVm.otp4, perform: { _ in
//                    if otpVm.otp4.count == 1 {
//                        otpVm.verifyphone(phone: phone)
//                    }
//                })
                
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
            
//            Button {
//                // phone verify
//                otpVm.verifyphone(phone: phone)
//            } label: {
//                ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.veify)
//                    .cornerRadius(12)
//            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $otpVm.verified, destination: {
            TabBarView()
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

struct EnterOTPView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationStack {
            EnterOTPView()
        }
    }
}
