//
//  PlaceSelectionView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 12/06/23.
//

import SwiftUI

struct PriceSelectionView: View {
    
    @Environment (\.dismiss) var dismiss
    var ride: PublishDetails
    @State private var price: Int = 120
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                ImageButton(image: AppConstants.AppImages.minus) {
                    price -= 10
                }
                .font(.largeTitle)
                .disabled(price == 70)
                
                Spacer()
                
                Text("Rs. \(price)")
                    .font(.system(size: 42))
                    .bold()
                    .foregroundColor(price > 130 ? .red : .green)
                
                Spacer()
                
                ImageButton(image: AppConstants.AppImages.plus) {
                    price += 10
                }
                .font(.largeTitle)
                .disabled(price == 160)
            }
            .padding(.top, 50)
            
            if price > 130 {
                
                HStack {
                    
                    Image(systemName: AppConstants.AppImages.exclamation)
                    Text(AppConstants.AppStrings.maxPriceLimit)
                }
                .padding(.top, 8)
                .font(.subheadline)
                .fontWeight(.medium)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                ButtonLabelView(buttonLabel: AppConstants.ButtonLabels.save)
                    .cornerRadius(12)
            }

        }
        .padding()
        .navigationTitle(AppConstants.AppHeadings.editPrice)
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
            price = Int(ride.setPrice)
        }
    }
}

struct PriceSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PriceSelectionView(ride: PublishRideResponse.publishRideResponse.publish)
        }
    }
}
