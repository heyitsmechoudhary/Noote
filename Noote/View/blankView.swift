//
//  blankView.swift
//  Noote
//
//  Created by Rahul choudhary on 31/03/25.
//

import SwiftUI

struct blankView: View {
    var body: some View {
        VStack{
            Spacer()
        }
        .frame(minWidth: 0,maxWidth: .infinity,minHeight: 0,maxHeight: .infinity,alignment: .center)
        .background(
            Color.black
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

#Preview {
    blankView()
}
