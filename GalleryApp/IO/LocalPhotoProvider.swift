//
//  LocalStorage.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 16.08.25.
//

import Foundation
import UIKit

enum LocalStorageError: Error {
    case failedToLoadImage
    case failedToSaveImage
    
    var description: String {
        switch self {
            case .failedToLoadImage:
                return "Failed to load image"
            case .failedToSaveImage:
                return "Failed to save image"
        }
    }
}

protocol LocalPhotoProvider: AnyObject {
    func isFavorite(_ id: String) -> Bool
    func allFavorites() -> [Photo]
    func toggleFavorite(_ photo: Photo) async
}

final class LocalPhotoProvider: ObservableObject {
    @Published private(set) var favorites: [String: Photo] = [:]
    private let key = "favorite_photos"
    private let defaults = UserDefaults.standard
    
    init() {
        load()
    }
    
    func isFavorite(_ id: String) -> Bool {
        favorites.contains { $0.key == id }
    }
    
    func allFavorites() -> [Photo] {
        return Array(self.favorites.values)
    }
    
    func toggleFavorite(_ photo: Photo) async {
        if favorites[photo.identifier] != nil {
            favorites.removeValue(forKey: photo.identifier)
        } else {
            favorites[photo.identifier] = photo
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
              let decoded = try? JSONDecoder()
            .decode(
                [String:Photo].self,
                from: data
            ) else {
            
            favorites = [:]
            return
        }
        favorites = decoded
    }
}

private extension LocalPhotoProvider {
    func saveImage(_ photoUrl: URL) async -> Result<URL, LocalStorageError>  {
        let httpClient = HTTPClient(session: .shared)
        
        let result : Result<Data, HTTPClient.ResponseError> = await httpClient.handleRequest(
            url: photoUrl,
            method: .GET,
            token: nil
        )
        
        var image : Data? = nil
        
        switch result {
            case .success(let success):
                image = success
            case .failure(_):
                return .failure(.failedToLoadImage)
        }
        
        guard let image = image else { return .failure(.failedToLoadImage) }
        guard let uiimage = UIImage(data: image) else { return .failure(.failedToLoadImage) }
        guard let data = uiimage.pngData() else { return .failure(.failedToSaveImage) }
        
        do {
            let filename = try FileManager
            .default
            .url(for: .picturesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("\(photoUrl.path()).jpg")

            try data.write(to: filename)
            return .success(filename)
        } catch {
            print("Error saving image: \(error)")
            return .failure(.failedToSaveImage)
        }
    }

    func loadImage(from url: URL) -> UIImage? {
        return UIImage(contentsOfFile: url.path)
    }
}
