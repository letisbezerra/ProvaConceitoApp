//
//  memory_appApp.swift
//  memory-app
//
//  Created by Beatriz Peixoto on 04/10/24.
//

import CoreData
import CloudKit
import SwiftUI
import UIKit

@main
struct memory_appApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
