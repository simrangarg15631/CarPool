//
//  EnterEmailView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 26/05/23.
//

import SwiftUI

struct EnterEmailView: View {
    
    @State private var email = String()
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            ImageButton(image: AppConstants.AppImages.multiply) {
                self.dismiss()
            }
            
            Headingview(title: AppConstants.AppHeadings.enterEmail)
            
            InputFieldView(placeholder: AppConstants.AppStrings.email,
                           keyBoardType: .emailAddress,
                           textFieldValue: $email)
            .padding(.top)
            
            Spacer()
            
            Button {
                
            } label: {
                ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.submit)
                    .cornerRadius(18)
            }
            
        }
        .padding()
    }
}

struct EnterEmailView_Previews: PreviewProvider {
    static var previews: some View {
        EnterEmailView()
    }
}
