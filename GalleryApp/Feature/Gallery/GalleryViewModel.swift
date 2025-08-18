//
//  GalleryViewModel.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 16.08.25.
//

import Foundation

@MainActor
final class GalleryViewModel: ObservableObject {
    @Published private(set) var photos: [Photo] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let router: Router<AppRoute>
    private let repository: PhotosRepository
    private let favorites: LocalPhotoProvider
    private var page = 1
    private let perPage = 30
    private var reachedEnd = false

    init(
        repository: PhotosRepository,
        favorites: LocalPhotoProvider,
        router: Router<AppRoute>
    ) {
        self.repository = repository
        self.favorites = favorites
        self.router = router
    }

    func pushToPhotoDetails(index: Int) {
        self.router.push(.detail(index: index))
    }
    func filterFavourites() {
        
    }
    
    func reload() {
        page = 1
        reachedEnd = false
        photos.removeAll()
        error = nil
        Task {
            await loadMoreIfNeeded(currentItem: nil)
        }
    }

    func isFavorite(_ id: String) -> Bool {
        favorites.isFavorite(id)
    }

    func toggleFavorite(_ id: String) {
        favorites.toggleFavorite(id)
        objectWillChange.send()
    }

    func loadMoreIfNeeded(currentItem: Photo?) async {
        guard !isLoading, !reachedEnd else {
            return
        }
        if
            let currentItem,
            let idx = photos.firstIndex(of: currentItem) {
            guard idx >= photos.count - 10 else {
                return
            }
        } else if !photos.isEmpty {
            // Only continue when scrolling
        }

        isLoading = true
        let new = await repository.listPhotos(page: page, perPage: perPage)
        switch new {
            case .success(let success):
                if success.isEmpty {
                    reachedEnd = true
                }
                photos.append(contentsOf: success)
                page += 1
                isLoading = false
            case .failure(let failure):
                self.error = "Failed to load photos. \(failure.description)"
                isLoading = false
        }
    }
}
