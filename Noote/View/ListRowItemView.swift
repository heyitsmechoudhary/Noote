//
//  ListRowItemView.swift
//  Noote
//
//  Created by Rahul choudhary on 04/04/25.
//

import SwiftUI

struct ListRowItemView: View {
    //MARK: - PROPERTIES
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var item: Item
    //MARK: - BODY
    var body: some View {
        Toggle(isOn: $item.completion){
            Text(item.task ?? "")
                .font(.system(.title2,design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(item.completion ? Color.pink : Color.primary)
                .padding(.vertical,12)
                .animation(.default)
        }//: TOGGLE
        .toggleStyle(CheckBoxStyleView())
        
        .onReceive(item.objectWillChange, perform: {_ in
            if self.viewContext.hasChanges {
                try? self.viewContext.save() 
            }
            
        })
    }
}
