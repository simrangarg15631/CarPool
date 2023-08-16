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
        
        NavigationStack {
            
            VStack {
                
                if !locVm.searchText.isEmpty {
                    if let searchRes = locVm.searchResults {
                        
                        List(searchRes, id: \.self) { res in
                            Button {
                                address = """
\(res.name ?? "") \(res.subLocality ?? "") \(res.locality ?? "") \(res.postalCode ?? "")
"""
                                coordinates = res.location?.coordinate ?? CLLocationCoordinate2D()

//                                    var recents = UserDefaults.standard.object(forKey: "RecentSearch") as? [[String:Any]] ?? []
//                                    recents.append([])
//                                    UserDefaults.standard.set(recents, forKey: "RecentSearch")
//                                locVm.recentSearches.append(res)
                                dismiss()
                            } label: {
                                SearchListRowView(searchResult: res)
                            }
                        }
                        .listStyle(.plain)
                    }
                    
                } else {
                    
                    Button {

                        coordinates = locVm.location?.coordinate ?? CLLocationCoordinate2D()
                        print(coordinates)
                        address = """
\(locVm.currentPlacemark?.name ?? "") \(locVm.currentPlacemark?.subLocality ?? "") \
\(locVm.currentPlacemark?.locality ?? "") \(locVm.currentPlacemark?.postalCode ?? "")
"""
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: AppConstants.AppImages.location)
                            Text(AppConstants.ButtonLabels.currLoc)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Add recent searches
//                    var recents: [String] = UserDefaults.standard.object(forKey: "RecentSearch") as? [String] ?? []
//
//                    List(recents, id: \.self) { res in
//                        Button {
////                            address = """
////\(res.name ?? "") \(res.subLocality ?? "") \(res.locality ?? "") \(res.postalCode ?? "")
////"""
////                            coordinates = res.location?.coordinate ?? CLLocationCoordinate2D()
//                            dismiss()
//                        } label: {
//                            Text(res)
////                            SearchListRowView(searchResult: res)
//                        }
//                    }
//                    .listStyle(.plain)
                }
                
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    ImageButton(image: AppConstants.AppImages.multiply) {
                        self.dismiss()
                    }
                })
            })
        }
        .searchable(text: $locVm.searchText, prompt: AppConstants.AppStrings.searchLoc)
        
    }
}

struct SearchLocationview_Previews: PreviewProvider {
    static var previews: some View {
        SearchLocationview(address: Binding.constant(""), coordinates: Binding.constant(CLLocationCoordinate2D()))
    }
}
