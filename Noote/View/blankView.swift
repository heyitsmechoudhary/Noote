//
//  blankView.swift
//  Noote
//
//  Created by Rahul choudhary on 31/03/25.
//

import SwiftUI

struct blankView: View {
    //MARK: - PROPERTIES
    var backgroundColor : Color
    var backgroundOpacity : Double
    //MARK: - BODY
    var body: some View {
        VStack{
            Spacer()
        }
        .frame(minWidth: 0,maxWidth: .infinity,minHeight: 0,maxHeight: .infinity,alignment: .center)
        .background(
            backgroundColor
                .opacity(backgroundOpacity)
                .blendMode(.overlay)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

#Preview {
    blankView(backgroundColor: Color.black, backgroundOpacity: 0.3)
        .background(BackgroundImageView())
        .background(backgroundGradiant.ignoresSafeArea(.all))
}
