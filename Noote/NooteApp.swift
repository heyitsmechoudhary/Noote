//
//  NooteApp.swift
//  Noote
//
//  Created by Rahul choudhary on 24/03/25.
//

import SwiftUI

@main
struct NooteApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
