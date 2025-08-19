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
    private lazy var galleryVM = GalleryViewModel(
      repository: photosRepo,
      favorites: localStorage,
      router: router
    )
    
    
    init(photosRepo: PhotosRepository, router: Router<AppRoute>, localStorage: LocalPhotoProvider) {
        self.photosRepo = photosRepo
        self.router = router
        self.localStorage = localStorage
    }
    
    func createGalleryView() -> some View {
        GalleryView(
            viewModel: self.galleryVM
        )
    }
    func createDetailsView(index : Int) -> some View {
        PhotoDetailView(viewModel: DetailViewModel(
            startIndex: index,
            gallery: self.galleryVM
        ))
    }
}
