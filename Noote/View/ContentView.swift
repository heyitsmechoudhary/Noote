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
    @AppStorage("isDarkmode") private var isDarkmode: Bool = false
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
                    HStack(spacing:10){
                        // TITLE
                        Text("Noote")
                            .font(.system(.largeTitle,design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading,4)
                        Spacer()
                        
                        // EDIT BUTTON
                        EditButton()
                            .font(.system(size: 16,weight: .semibold,design: .rounded))
                            .padding(.horizontal,10)
                            .frame(minWidth: 70,minHeight: 24)
                            .background(
                                
                                Color.white
                                    .clipShape(Capsule().stroke(lineWidth: 2))
                            )
                        // APPEARENCE BUTTON
                        
                        Button(action: {
                            //some action
                            isDarkmode.toggle()
                        }, label: {
                            Image(systemName: isDarkmode ? "moon.circle.fill" : "moon.circle")
                                .font(.system(size: 24,weight: .semibold,design: .rounded))
                        })
                        
                    }//:HSTACK
                    .padding()
                    .foregroundColor(.white)
                    
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
                            ListRowItemView(item: item)
                        }
                        .onDelete(perform: deleteItems)
                    }//: LIST
                    .listStyle(InsetGroupedListStyle())
                    .shadow(radius: 10)
                    .padding(.vertical,0)
                    .frame(maxWidth: 640)
                }//: VSTACK
                .blur(radius: showNewTaskItem ? 8.0 : 0,opaque: false)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.5))
                //MARK: - NEW TASK ITEM
                if showNewTaskItem {
                    blankView(
                        backgroundColor: isDarkmode ? Color.black : Color.gray,
                        backgroundOpacity: isDarkmode ? 0.3 : 0.5
                    )
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
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.large)
            .background(
                BackgroundImageView()
                    .blur(radius: showNewTaskItem ? 8.0 : 0,opaque: false)
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
