//
//  SearchLocationview.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 16/05/23.
//

import SwiftUI
import CoreLocation

struct SearchLocationview: View {
    
    @StateObject var locVm = SearchLocationViewModel()
    @Binding var address: String
    @Binding var coordinates: CLLocationCoordinate2D
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            ImageButton(image: AppConstants.AppImages.multiply) {
                self.dismiss()
            }
            .font(.title2)
            
            TextField(AppConstants.AppStrings.searchLoc, text: $locVm.searchText)
                .padding(12)
                .background(Color.gray.opacity(0.2))
            
            if !locVm.searchText.isEmpty {
                if let searchRes = locVm.searchResults {
                    
                    List(searchRes, id: \.self) { res in
                        Button {
                            address = """
\(res.name ?? "") \(res.subLocality ?? "") \(res.locality ?? "") \(res.postalCode ?? "")
"""
                            coordinates = res.location?.coordinate ?? CLLocationCoordinate2D()
                            dismiss()
                        } label: {
                            SearchListRowView(searchResult: res)
                        }
                    }
                    .listStyle(.plain)
                }
                
            } else {
                // Add recent searches
            }
            
            Spacer()
            
        }
        .padding()
    }
}

struct SearchLocationview_Previews: PreviewProvider {
    static var previews: some View {
        SearchLocationview(address: Binding.constant(""), coordinates: Binding.constant(CLLocationCoordinate2D()))
    }
}
