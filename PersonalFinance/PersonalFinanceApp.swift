//
//  PersonalFinanceApp.swift
//  PersonalFinance
//
//  Created by Mahmoud Fouad on 30/12/2021.
//

import SwiftUI

@main
struct PersonalFinanceApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
