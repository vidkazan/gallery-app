//
//  LocalStorage.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 16.08.25.
//

import Foundation

final class LocalPhotoProvider: ObservableObject {
    @Published private(set) var favorites: [Photo] = []
    private let key = "favorite_photos"
    private let defaults = UserDefaults.standard
    
    init() {
        load()
    }
    
    func isFavorite(_ id: String) -> Bool {
        favorites.contains { $0.id == id }
    }
    
    func toggleFavorite(_ photo: Photo) {
        if let idx = favorites.firstIndex(where: { $0.id == photo.id }) {
            favorites.remove(at: idx)
        } else {
            favorites.append(photo)
        }
        save()
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(favorites) {
            defaults.set(data, forKey: key)
        }
    }
    
    private func load() {
        guard let data = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Photo].self, from: data) else {
            favorites = []
            return
        }
        favorites = decoded
    }
}
