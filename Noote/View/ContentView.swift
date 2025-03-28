//
//  ContentView.swift
//  Noote
//
//  Created by Rahul choudhary on 24/03/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //MARK: - PROPERTIES
    @State var task: String = ""
    private var isButtonDisabled: Bool { task.isEmpty }
    
    @Environment(\.managedObjectContext) private var viewContext
    // FETCHING DATA
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    //MARK: - FUNCTION
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
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            
        }
    }
    //create a function for throw a toast error message if user try to save empty task
    private func showToast(message: String, duration: Double = 2.0) {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25;
        toastContainer.clipsToBounds  =  true
        
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.systemPink
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        
        toastContainer.addSubview(toastLabel)
        window.addSubview(toastContainer)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let labelConstraints = [
            toastLabel.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 15),
            toastLabel.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -15),
            toastLabel.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 15),
            toastLabel.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor, constant: -15)
        ]
        let containerConstraints = [
            toastContainer.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            toastContainer.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -90),
            toastContainer.leadingAnchor.constraint(greaterThanOrEqualTo: window.leadingAnchor, constant: 25),
            toastContainer.trailingAnchor.constraint(lessThanOrEqualTo: window.trailingAnchor, constant: -25)
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
        NSLayoutConstraint.activate(containerConstraints)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
    
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack(spacing: 15,content: {
                        TextField("New task", text: $task)
                            .padding()
                            .background(
                                Color(UIColor.systemGray6)
                            )
                            .cornerRadius(10)
                        Button(action: {
                            addItem()
                            task = ""
                            hidekeyboard()
                            
                        } ,label: {
                            Spacer()
                            Text("SAVE")
                            Spacer()
                        })
                        .disabled(isButtonDisabled)
                        .padding()
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(isButtonDisabled ? Color.gray : Color.pink)
                        .cornerRadius(10)
                    })//:VSTACK
                    .padding()
                    List {
                        ForEach(items) { item in
                            VStack(alignment: .leading){
                                Text(item.task ?? "")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text(item.timestamp!, formatter: itemFormatter)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }//: LIST
                    .listStyle(InsetGroupedListStyle())
                    .shadow(radius: 10)
                    .padding(.vertical,0)
                    .frame(maxWidth: 640)
                }//: VSTACK
            }//:ZSTACK
            .onAppear(){
                UITableView.appearance().backgroundColor = UIColor.clear //i am encountering issue while removing the backgroud fix this anyone of you can
            }
            .navigationTitle("Daily Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }//: TOOLBAR
            .background(
                BackgroundImageView()
            )
            .background(
                backgroundGradiant.ignoresSafeArea(.all)
            )
        }//: NAVIGATION
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


//MARK: - PREVIEW

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
