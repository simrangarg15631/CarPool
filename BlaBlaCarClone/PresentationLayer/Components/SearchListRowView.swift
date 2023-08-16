//
//  SearchListRowView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 16/05/23.
//

import SwiftUI
import CoreLocation

struct SearchListRowView: View {
    
    var searchResult: CLPlacemark
    
    var body: some View {
        
        HStack {
            
            Image(systemName: AppConstants.AppImages.mappin)
            
            VStack(alignment: .leading) {
                
                Text(searchResult.name ?? "")
                    .font(.headline)
                
                Text("\(searchResult.subLocality ?? "") \(searchResult.locality ?? "") \(searchResult.postalCode ?? "")")
                    .opacity(0.6)
                    .font(.subheadline)
            }
        }
    }
}

// struct SearchListRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchListRowView(searchResult: CLPlacemark())
//    }
// }
