//
//  SignUpDOBView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 10/05/23.
//

import SwiftUI

struct SignUpDOBView: View {
    
    @ObservedObject var vm: SignUpViewModel
    @Environment (\.dismiss) var dismiss
    @Binding var next: Bool
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            ProgressBarView(currentValue: vm.currentValue, totalValue: vm.totalValue)
            
            Headingview(title: AppConstants.AppHeadings.whatsYourDob)
            
            if let date = vm.date {
                DatePicker(AppConstants.AppHeadings.whatsYourDob,
                           selection: $vm.dateOfBirth,
                           in: ...date,
                           displayedComponents: .date)
                .datePickerStyle(.graphical)
                .frame(maxHeight: 400)
            }
            
            Spacer()
            
            // Next Button
            NavigationLink(destination: {
                // Navigate to signUpGenderView to enter gender
                SignUpGenderView(vm: vm)
            }, label: {
                ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.next)
                    .cornerRadius(18)
            })
        }
        .onAppear {
            // Progress bar value
            vm.currentValue = 2
            next = false
            if let dob = vm.date {
                vm.dateOfBirth = dob
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
    }
}

struct SignUpDOBView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpDOBView(vm: SignUpViewModel(), next: Binding.constant(false))
        }
    }
}
