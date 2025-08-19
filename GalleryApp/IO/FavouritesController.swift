//
//  LocalStorage.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 16.08.25.
//

import Foundation
import UIKit

protocol FavouritesController {
    func isFavorite(_ id: String) -> Bool
    func toggleFavorite(_ photo: Photo) async
}

enum FavouritesControllerError: Error {
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
