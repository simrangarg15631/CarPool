//  SelectRouteView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 01/06/23.

import SwiftUI
import MapKit

struct SelectRouteView: View {
    
    @Binding var pathString: String
    @Binding var region: MKCoordinateRegion
    
    var body: some View {
        
        VStack {
            
            MapView(region: region, pathString: pathString)
                .edgesIgnoringSafeArea(.horizontal)
            
            NavigationLink {
               RideCreatedView()
            } label: {
                ButtonLabelView(buttonLabel: "Proceed")
                    .cornerRadius(12)
            }
            .frame(height: 100)
            .padding()

        }

    }
}

struct SelectRouteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SelectRouteView(pathString: Binding.constant(String()), region: Binding.constant(MKCoordinateRegion()))
        }
    }
}
