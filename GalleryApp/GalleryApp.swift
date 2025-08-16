//
//  GalleryAppApp.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 15.08.25.
//

import SwiftUI

@main
struct GalleryAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
