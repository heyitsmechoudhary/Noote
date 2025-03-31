//
//  BackgroundImageView.swift
//  Noote
//
//  Created by Rahul choudhary on 28/03/25.
//

import SwiftUI

struct BackgroundImageView: View {
    var body: some View {
        Image("rocket")
            .antialiased(true)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea(.all)
        
    }
}

#Preview {
    BackgroundImageView()
}
