//
//  LocalStorage.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 16.08.25.
//

import Foundation
import UIKit

final class UserDefaultsPhotoProvider {
    private(set) var favorites: [String: Photo] = [:]
    private let key = "favorite_photos"
    private let defaults = UserDefaults.standard
    
    init() {
        load()
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
    
    private func allFavorites() -> [Photo] {
        self.load()
        return Array(self.favorites.values)
    }
}

extension UserDefaultsPhotoProvider: FavouritesController {
    func isFavorite(_ id: String) -> Bool {
        favorites.contains { $0.key == id }
    }
    
    func toggleFavorite(_ photo: Photo) async {
        if favorites[photo.identifier] != nil {
            favorites.removeValue(forKey: photo.identifier)
        } else {
            favorites[photo.identifier] = photo
        }
        save()
        self.load()
    }
}

extension UserDefaultsPhotoProvider: FavouritesRepository {
    func favourites() async -> Result<[Photo], Error> {
        return .success(self.allFavorites())
    }
    
    func loadPhoto(url: URL) async -> Result<UIImage, Error> {
        if self.hasImage(url: url) == true {
            guard let image = self.loadImage(from: url) else {
                return .failure(FavouritesControllerError.failedToLoadImage)
            }
            return .success(image)
        }
        
        let response = await self.fetchImage(url: url)
        
        switch response {
            case .success(let success):
                guard let image = UIImage(data: success) else {
                    return .failure(FavouritesControllerError.failedToLoadImage)
                }
                return .success(image)
            case .failure:
                return .failure(FavouritesControllerError.failedToLoadImage)
        }
    }
}

private extension UserDefaultsPhotoProvider {
    func fetchImage(url : URL) async -> Result<Data, HTTPClient.ResponseError> {
        let httpClient = HTTPClient(session: .shared)
        
        let result : Result<Data, HTTPClient.ResponseError> = await httpClient.handleRequest(
            url: url,
            method: .GET,
            token: nil
        )
        return result
    }
    
    func saveImage(_ photoUrl: URL) async -> Result<URL, FavouritesControllerError>  {
        var image : Data? = nil
        
        let result = await self.fetchImage(url: photoUrl)
        
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

    func hasImage(url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    func loadImage(from url: URL) -> UIImage? {
        return UIImage(contentsOfFile: url.path)
    }
}
