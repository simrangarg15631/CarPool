//
//  OtpFieldView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 09/06/23.
//

import SwiftUI

struct OtpFieldView: View {
    
    @Binding var value: String
    @Binding var isEmpty: Bool
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.gray.opacity(0.4))
                .frame(height: 48)
            
            EnhancedTextField(placeholder: "", text: $value) { onEmpty in
                print("Backspace pressed, onEmpty? \(onEmpty) at \(Date().ISO8601Format())")
                if onEmpty {
                    isEmpty.toggle()
                }
            }
            .padding(12)
            .background(.clear)
            .autocorrectionDisabled(true)
            .keyboardType(.numberPad)
            .frame(width: 40, height: 48)
            
            //            TextField("", text: $value)
            //                .padding(12)
            //                .background(.clear)
            //                .autocorrectionDisabled(true)
            //                .keyboardType(.numberPad)
            //                .frame(width: 40)
            
        }
    }
}

struct OtpFieldView_Previews: PreviewProvider {
    static var previews: some View {
        OtpFieldView(value: Binding.constant(""), isEmpty: Binding.constant(false))
    }
}
