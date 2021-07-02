//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Alexander Bonney on 5/27/21.
//

import SwiftUI

@main
struct BookwormApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
