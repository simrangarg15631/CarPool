//
//  PriceView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 14/08/23.
//

import SwiftUI

struct PriceView: View {
    
    @Environment (\.dismiss) var dismiss
    @ObservedObject var publishVm: PublishRideViewModel
    
    var body: some View {
        
        VStack {
            PriceSelectCOmponent(price: $publishVm.price)
            
            Spacer()
            
            NavigationLink {
                RideCreatedView(publishVm: publishVm)
            } label: {
                ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.proceed)
                    .cornerRadius(12)
            }
            .frame(height: 100)
        }
        .padding()
        .navigationTitle(AppConstants.AppStrings.priceSeat)
        .navigationBarTitleDisplayMode(.large)
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
            if publishVm.dismiss {
                self.dismiss()
            }
        }
    }
}

struct PriceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PriceView(publishVm: PublishRideViewModel())
        }
    }
}
