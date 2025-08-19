//
//  GalleryAppApp.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 15.08.25.
//

import SwiftUI

@main
struct GalleryApp: App {
    var body: some Scene {
        let photosRepo : PhotosRepository = RemotePhotosRepository()
        let router: Router<AppRoute> = .init()
        let builder: GalleryAppViewBuilder = .init(
            photosRepo: photosRepo,
            router: router
        )
        
        WindowGroup {
            MainAppView(
                router: router,
                viewBuilder: builder
            )
        }
    }
}
