//
//  SwiftUIView.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 10/08/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            if UserSession.shared.isSessionValid() {
                TabBarView()
            } else {
                OnboardingView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
