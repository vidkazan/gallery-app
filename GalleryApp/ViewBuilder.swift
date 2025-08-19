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
    private lazy var galleryVM = GalleryViewModel(
      repository: photosRepo,
      favorites: UserDefaultsPhotoProvider(),
      router: router,
    )
    
    private lazy var userDefaultsPhotoProvider = UserDefaultsPhotoProvider()
    
    init(photosRepo: PhotosRepository, router: Router<AppRoute>) {
        self.photosRepo = photosRepo
        self.router = router
    }
    
    func createFavouritesView() -> some View {
        GalleryView(
            viewModel: GalleryViewModel(
                repository: self.userDefaultsPhotoProvider,
                favorites: self.userDefaultsPhotoProvider,
                router: self.router
            )
        )
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
