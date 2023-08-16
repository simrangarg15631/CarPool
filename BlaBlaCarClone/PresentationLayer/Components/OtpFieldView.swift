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
            
            EnhancedTextField(text: $value, keyboardType: .numberPad) { onEmpty in
                if onEmpty {
                    isEmpty.toggle()
                }
            }
            .padding(12)
            .background(.clear)
            .frame(height: 48)
            .multilineTextAlignment(.center)
        }
    }
}

struct OtpFieldView_Previews: PreviewProvider {
    static var previews: some View {
        OtpFieldView(value: Binding.constant(""), isEmpty: Binding.constant(false))
    }
}
