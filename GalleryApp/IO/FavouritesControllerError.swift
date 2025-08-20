//
//  FavouritesControllerError.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 20.08.25.
//


import Foundation
import UIKit

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