//
//  RideDetailComponent.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 19/05/23.
//

import SwiftUI

struct RideDetailComponent: View {
    var title: String
    var time: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            
            Text(title)
                .font(.headline)
            Text(time)
                .font(.subheadline)
                .opacity(0.7)
            
        }
        .foregroundColor(.black)
    }
}

struct RideDetailComponent_Previews: PreviewProvider {
    static var previews: some View {
        RideDetailComponent(title: "PickUp Location",
                            time: "Time")
    }
}
