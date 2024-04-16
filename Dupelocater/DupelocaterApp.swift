//
//  DupelocaterApp.swift
//  Dupelocater
//
//  Created by Jayla Scott on 1/26/24.
//

import SwiftUI

@main
struct DupelocaterApp: App {
    let persistenceController = PersistenceController.shared
    let viewModel = ChatBox.ViewModel() // Initialize your ViewModel here
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
