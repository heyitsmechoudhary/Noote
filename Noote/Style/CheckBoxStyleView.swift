//
//  CheckBoxStyleView.swift
//  Noote
//
//  Created by Rahul choudhary on 04/04/25.
//

import SwiftUI

struct CheckBoxStyleView: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack{
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .pink : .primary)
                .font(.system(size: 30,weight: .semibold,design: .rounded))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }//: HSTACK
    }
}

#Preview {
    Toggle("Placeholder text",isOn: .constant(false))
        .toggleStyle(CheckBoxStyleView())
        .padding()
        
}
