//
//  PhotoDetailsViewModel.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 17.08.25.
//

import Foundation
import SwiftUICore

@MainActor
final class DetailViewModel: ObservableObject {
    @Published var index: Int
    @ObservedObject private var gallery: GalleryViewModel

    init(startIndex: Int, gallery: GalleryViewModel) {
        self.index = startIndex
        self.gallery = gallery
    }

    var photos: [Photo] {
        gallery.photos
    }

    var currentPhoto: Photo? {
        guard photos.indices.contains(index) else { return nil }
        return photos[index]
    }

    func isFavorite(_ id: String) -> Bool {
        gallery.isFavorite(id)
    }

    func toggleFavorite(_ photo: Photo) async {
        await gallery.toggleFavorite(photo)
        objectWillChange.send()
    }

    func goNext() { if index < photos.count - 1 { index += 1 } }
    func goPrev() { if index > 0 { index -= 1 } }
}
