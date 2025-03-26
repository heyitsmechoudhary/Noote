//
//  Persistence.swift
//  Noote
//
//  Created by Rahul choudhary on 24/03/25.
//

import CoreData

struct PersistenceController {
    //MARK: - PERSISTEN CONTAINER
    static let shared = PersistenceController()


    //MARK: - PERSISTENT CONTAINER
    let container: NSPersistentContainer

    //MARK: - INTIALIZATION (load the persistent store)
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Noote")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    //MARK: - PREVIEW
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<5 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = "Sample task \(i)"
            newItem.completion = false
            newItem.id = UUID()
//            newItem.description = "Sample description \(i)"
        }
        do {
            try viewContext.save()
        } catch {
            
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
