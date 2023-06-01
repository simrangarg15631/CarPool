//
//  PublishRowComponent.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 01/06/23.
//

import SwiftUI

struct PublishRowComponent: View {
    
    var title: String
    var subTitle: String
    @Binding var isPresented: Bool
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .opacity(0.7)
                .padding(.top, 20)
            
            Button {
                isPresented.toggle()
            } label: {
                HStack {
                    Text(subTitle)
                        
                    Spacer()
                    
                    Image(systemName: AppConstants.AppImages.chevronDown)
                }
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(.top, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(.gray.opacity(0.8))
        }
    }
}

struct PublishRowComponent_Previews: PreviewProvider {
    static var previews: some View {
        PublishRowComponent(title: "Available Seats", subTitle: "1", isPresented: Binding.constant(true))
    }
}
