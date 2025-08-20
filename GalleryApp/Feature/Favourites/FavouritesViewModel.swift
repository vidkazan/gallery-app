//
//  FavouritesViewModel.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 20.08.25.
//

import Foundation

@MainActor
final class FavouritesViewModel: ObservableObject {
    @Published private(set) var photos: [Photo] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let router: Router<AppRoute>
    private let repository: FavouritesRepository
    private let favorites: FavouritesController

    init(
        repository: FavouritesRepository,
        favorites: FavouritesController,
        router: Router<AppRoute>
    ) {
        self.repository = repository
        self.favorites = favorites
        self.router = router
    }
    
    func reload() {
        photos.removeAll()
        error = nil
        Task(priority: .background) {
            await loadPhotos()
        }
    }

    func popToGallery() {
        self.router.pop()
    }
    
    func isFavorite(_ id: String) -> Bool {
        favorites.isFavorite(id)
    }

    func loadPhotos() async {
        guard !isLoading else {
            return
        }

        isLoading = true
        let new = await repository.favourites()
        switch new {
            case .success(let success):
                photos = success
            case .failure(let failure):
                self.error = "Failed to load photos. \(failure.localizedDescription)"
        }
        isLoading = false
    }
}
