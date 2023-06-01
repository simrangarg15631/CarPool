//
//  VehicleRow.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 29/05/23.
//

import SwiftUI

struct VehicleRow: View {
    
    var title1: String
    var title2: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(title1)
                .font(.subheadline)
            Text(title2)
                .font(.headline)
                .foregroundColor(.accentColor)
        }
    }
}

struct VehicleRow_Previews: PreviewProvider {
    static var previews: some View {
        VehicleRow(title1: "", title2: "")
    }
}
