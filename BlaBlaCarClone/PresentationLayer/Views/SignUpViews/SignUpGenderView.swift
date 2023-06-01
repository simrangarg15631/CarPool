//
//  SignUpGenderView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 10/05/23.
//

import SwiftUI

struct SignUpGenderView: View {
    
    @ObservedObject var vm: SignUpViewModel
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            ProgressBarView(currentValue: vm.currentValue, totalValue: vm.totalValue)
            
            Headingview(title: AppConstants.AppHeadings.whatsYourgender)
            
            Picker(AppConstants.AppStrings.gender, selection: $vm.gender) {
                
                ForEach(vm.genderType, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.wheel)
            
            Spacer()
            
            if vm.isLoading {
                ProgressView()
                    .padding(.bottom, 20)
            }
            
            // Next Button
            NavigationLink {
                // Navigate to SignUpPhoneView to enter phone number
                SignUpPhoneView(vm: vm)
            }label: {
                ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.next)
                    .cornerRadius(18)
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
            // progress bar value
            vm.currentValue = 3
        }
//        .navigationDestination(isPresented: $vm.signUpActive, destination: {
//            SignUpPhoneView(vm: vm)
//        })
        // Show alert if there is error
//        .alert("", isPresented: $vm.hasError) {
//            Button(AppConstants.ButtonLabels.ok, role: .cancel) {}
//        } message: {
//            if let error = vm.errorMessage {
//                Text(error.localizedDescription)
//                    .font(.headline)
//            }
//        }
    }
}

struct SignUpGenderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpGenderView(vm: SignUpViewModel())
        }
    }
}
