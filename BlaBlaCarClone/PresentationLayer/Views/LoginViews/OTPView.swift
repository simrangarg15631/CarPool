//
//  OTPView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 05/06/23.
//

import SwiftUI
import Foundation

struct OTPView: View {
    
    @StateObject var otpVm = OTPViewModel()
    @ObservedObject var enterVm: EnterEmailViewModel
    @Environment (\.dismiss) var dismiss
    @FocusState var isFocused: TextFieldType?
    
    @State var timeRemaining = 60
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var email = String()
    
    var timerTxt: AttributedString {
        let timeTxt = timeRemaining < 10 ? "0\(timeRemaining)" : "\(timeRemaining)"
        var result = AttributedString("00:" + timeTxt)
        result.font = .headline
        result.foregroundColor = .accentColor
        result.underlineStyle = Text.LineStyle(pattern: .solid, color: .accentColor)
        return "Resend OTP in " + result
    }
    
    var body: some View {
        
        VStack {
            
            Headingview(title: AppConstants.AppHeadings.enterOtp)
            
            HStack {
                Spacer()
                
                OtpFieldView(value: $otpVm.otp1, isEmpty: $otpVm.otp1Emp)
                    .focused($isFocused, equals: .otp1)
                    .onChange(of: otpVm.otp1, perform: { _ in
                        print(otpVm.otp1)
                        if otpVm.otp1.count == 1 {
                            isFocused = .otp2
                        }
                    })
                
                OtpFieldView(value: $otpVm.otp2, isEmpty: $otpVm.otp2Emp)
                    .focused($isFocused, equals: .otp2)
                    .onChange(of: otpVm.otp2, perform: { _ in
                        if otpVm.otp2.count == 1 {
                            isFocused = .otp3
                        }
                    })
                    .onChange(of: otpVm.otp2Emp, perform: { _ in
                        isFocused = .otp1

                    })
                
                OtpFieldView(value: $otpVm.otp3, isEmpty: $otpVm.otp3Emp)
                    .focused($isFocused, equals: .otp3)
                    .onChange(of: otpVm.otp3, perform: { _ in
                        if otpVm.otp3.count == 1 {
                            isFocused = .otp4
                        }
                    })
                    .onChange(of: otpVm.otp3Emp, perform: { _ in
                        isFocused = .otp2
                    })
                
                OtpFieldView(value: $otpVm.otp4, isEmpty: $otpVm.otp4Emp)
                .focused($isFocused, equals: .otp4)
                .onChange(of: otpVm.otp4, perform: { _ in
                    if otpVm.otp4.count == 1 {
                        isFocused = nil
                    }
                })
                .onChange(of: otpVm.otp4Emp, perform: { _ in
                    isFocused = .otp3

                })
                
                Spacer()
            }
            .padding(.top)
            
            Text(timerTxt)
                .padding(.top)
            
            Button(action: {
                enterVm.sendOtp(email: email)
                timeRemaining = 60
            }, label: {
                Text("Resend OTP")
                    .font(.headline)
            })
            .padding(.top, 4)
            .disabled(timeRemaining != 0)
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
            
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
        .onAppear {
            isFocused = .otp1
        }
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
            OTPView(enterVm: EnterEmailViewModel())
        }
    }
}
