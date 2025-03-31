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
    @State private var showNewTaskItem: Bool = false
    
    
    @Environment(\.managedObjectContext) private var viewContext
    // FETCHING DATA
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    //MARK: - FUNCTION
    

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
   
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                //MARK: - MAIN VIEW
                VStack {
                    //MARK: - HEADER
                    Spacer(minLength: 80)
                    //MARK: - NEW TASK BUTTON
                    Button(action: {
                        showNewTaskItem = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30,weight: .semibold,design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24,weight: .bold,design: .rounded))
                    })
                    .foregroundColor(.white)
                    .padding(.horizontal,20)
                    .padding(.vertical,15)
                    .background(
                        backgroundGradiant
                            .clipShape(Capsule())
                    )
                    .shadow(radius: 8)
                    
                    //MARK: - TASKS
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
                //MARK: - NEW TASK ITEM
                if showNewTaskItem {
                    blankView()
                        .onTapGesture {
                            withAnimation(){
                                showNewTaskItem = false
                            }
                        }
                    newTaskItemView(isShowing: $showNewTaskItem)
                }
            }//:ZSTACK
            
//            .onAppear {
//                UITableView.appearance().backgroundColor = .clear
//                UITableViewCell.appearance().backgroundColor = .clear
//            }
            
            .scrollContentBackground(.hidden) // Hides default background
            .background(Color.clear) // Ensures transparency

            .navigationTitle("Daily Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
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
