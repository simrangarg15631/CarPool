//
//  PriceSelectCOmponent.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 14/08/23.
//

import SwiftUI

struct PriceSelectCOmponent: View {
    
    @Binding var price: Int
    @State private var avgPrice: Int = Int()
    
    var body: some View {
        VStack {
            HStack {
                ImageButton(image: AppConstants.AppImages.minus) {
                    price -= 10
                }
                .font(.largeTitle)
                .disabled(price == avgPrice - 60 || price == 0)
                
                Spacer()
                
                Text("Rs. \(price)")
                    .font(.system(size: 42))
                    .bold()
                    .foregroundColor(price > avgPrice ? .red : .green)
                
                Spacer()
                
                ImageButton(image: AppConstants.AppImages.plus) {
                    price += 10
                }
                .font(.largeTitle)
                .disabled(price == avgPrice + 30)
            }
            .padding(.top, 50)
            
            if price > avgPrice {
                
                HStack {
                    
                    Image(systemName: AppConstants.AppImages.exclamation)
                    Text(AppConstants.AppStrings.maxPriceLimit)
                }
                .padding(.top, 8)
                .font(.subheadline)
                .fontWeight(.medium)
            }
        }
        .onAppear {
            avgPrice = price + 10
        }
    }
}

struct PriceSelectCOmponent_Previews: PreviewProvider {
    static var previews: some View {
        PriceSelectCOmponent(price: Binding.constant(0))
    }
}
