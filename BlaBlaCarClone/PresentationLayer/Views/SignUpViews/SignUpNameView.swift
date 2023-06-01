//
//  SignUpNameView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 25/05/23.
//

import SwiftUI

struct SignUpNameView: View {
    
    @ObservedObject var vm: SignUpViewModel
    @State private var next = true
    @Environment (\.dismiss) var dismiss
    var body: some View {
        
        VStack(alignment: .leading) {
            
            ProgressBarView(currentValue: vm.currentValue, totalValue: vm.totalValue)
            
            Headingview(title: AppConstants.AppHeadings.whatsYourName)
            
            InputFieldView(
                placeholder: AppConstants.AppStrings.firstName,
                textInputAutocapitalization: .words,
                textFieldValue: $vm.firstName)
                .padding(.top, 20)
            
            InputFieldView(
                placeholder: AppConstants.AppStrings.lastName,
                textInputAutocapitalization: .words,
                textFieldValue: $vm.lastName)
                .padding(.top, 20)
            
            Spacer()
            
            if next {
                NavigationLink(destination: {
                    // Navigate to signUpDOBView to enter DOB
                    SignUpDOBView(vm: vm, next: $next)
                }, label: {
                    ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.next)
                        .cornerRadius(18)
                })
                .opacity(vm.disableNextBtn() ? 0.5 : 1)
                .disabled(vm.disableNextBtn())
            }
        }
        .padding()
        .navigationTitle(AppConstants.AppHeadings.finishSignUp)
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
        .onAppear {
            // Progress Bar value
            vm.currentValue = 1
            next = true
        }
    }
}

struct SignUpNameView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpNameView(vm: SignUpViewModel())
    }
}
