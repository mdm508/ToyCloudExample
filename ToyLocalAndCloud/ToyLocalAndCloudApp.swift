//
//  ToyLocalAndCloudApp.swift
//  ToyLocalAndCloud
//
//  Created by m on 11/1/23.
//

import SwiftUI

@main
struct ToyLocalAndCloudApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
