//
//  detailView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 19/05/23.
//

import SwiftUI

struct DetailView: View {
    
    var image: String
    var text: String
    var color: Color = .black
    
    var body: some View {
        
        HStack {
            Image(systemName: image)
                .foregroundColor(color)
            Text(text)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(image: AppConstants.AppImages.calendar, text: "Day, date")
    }
}
