//
//  SearchListRowView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 16/05/23.
//

import SwiftUI
import MapKit

struct SearchListRowView: View {
    
    var searchResult: CLPlacemark
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(searchResult.name ?? "")
            
            Text("\(searchResult.subLocality ?? "") \(searchResult.locality ?? "") \(searchResult.postalCode ?? "")")
                .opacity(0.6)
        }
    }
}

// struct SearchListRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchListRowView(searchResult: CLPlacemark())
//    }
// }
