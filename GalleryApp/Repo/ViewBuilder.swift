//
//  ViewBuilder.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 17.08.25.
//

import Foundation
import SwiftUI

@MainActor
final class GalleryAppViewBuilder {
    let photosRepo: PhotosRepository
    let router: Router<AppRoute>
    let localStorage: LocalPhotoProvider

    init(photosRepo: PhotosRepository, router: Router<AppRoute>, localStorage: LocalPhotoProvider) {
        self.photosRepo = photosRepo
        self.router = router
        self.localStorage = localStorage
    }

    func createGalleryView() -> some View {
        GalleryView(
            viewModel: GalleryViewModel(
                repository: self.photosRepo,
                favorites: self.localStorage,
                router: self.router
            )
        )
    }
}
