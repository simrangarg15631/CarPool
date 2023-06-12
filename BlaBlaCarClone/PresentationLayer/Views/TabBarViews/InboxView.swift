//
//  InboxView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 18/05/23.
//

import SwiftUI

struct InboxView: View {
    var body: some View {
        
        VStack {
            
            HStack {
                
                Text(AppConstants.AppHeadings.inbox)
                    .font(.largeTitle)
                    .bold()
                    
                Spacer()
            }
            .padding()
            
            Image(AppConstants.AppImages.inbox)
                .resizable()
                .frame(maxWidth: 300, maxHeight: 300)
            
            Text(AppConstants.AppStrings.noMessages)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.top, 30)
                .opacity(0.8)
            
            Spacer()
        }
        .padding()
        
    }
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
}
