//
//  NoRides.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 02/06/23.
//

import SwiftUI

struct NoRides: View {
    
    var size: CGFloat
    
    var body: some View {
        
        VStack {
            
            Image(AppConstants.AppImages.noRides)
                .resizable()
                .frame(width: size, height: size)
            
            Headingview(title: AppConstants.AppHeadings.NoRides)
                .fontWeight(.semibold)
        }
        
    }
}

struct NoRides_Previews: PreviewProvider {
    static var previews: some View {
        NoRides(size: UIScreen.main.bounds.width)
    }
}
