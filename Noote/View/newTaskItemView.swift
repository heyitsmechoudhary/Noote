//
//  newTaskItemView.swift
//  Noote
//
//  Created by Rahul choudhary on 31/03/25.
//

import SwiftUI

struct newTaskItemView: View {
    //MARK: - PROPERTIES
    @AppStorage("isDarkmode") private var isDarkmode: Bool = false

    @Environment(\.managedObjectContext) private var viewContext
    @State private var task: String = ""
    @Binding var isShowing: Bool
    
    private var isButtonDisabled: Bool { task.isEmpty }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            task = ""
            hidekeyboard()
            isShowing = false
            
        }
    }
    //MARK: - BODY
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 15,content: {
                TextField("New task", text: $task)
                    .foregroundColor(.pink)
                    .font(.system(size: 24,weight: .bold,design: .rounded))
                    .padding()
                    .background(
                        isDarkmode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                    )
                    .cornerRadius(10)
                Button(action: {
                    addItem()
                    playSound(name: "ding")
                    hapticFeedback.notificationOccurred(.success)
                } ,label: {
                    Spacer()
                    Text("SAVE")
                        .font(.system(size: 24,weight: .bold,design: .rounded))
                    Spacer()
                })
                .disabled(isButtonDisabled)
                .onTapGesture{
                    if isButtonDisabled {
                        playSound(name: "tap")
                        hapticFeedback.notificationOccurred(.warning)
                    }
                }
                .padding()
                
                .foregroundColor(.white)
                .background(isButtonDisabled ? Color.blue : Color.pink)
                .cornerRadius(10)
            })//:VSTACK
            .padding(.horizontal)
            .padding(.vertical,20)
            .background(
                isDarkmode ? Color(UIColor.secondarySystemBackground) :  Color.white
            )
            .cornerRadius(16)
            .shadow(radius: 24)
            .frame(maxWidth:640)
        }//:VSTACK
        .padding()
    }
}
//MARK: - PREVIEW
#Preview {
    newTaskItemView(isShowing: .constant(true))
        .background(Color.gray.ignoresSafeArea(.all))
}
