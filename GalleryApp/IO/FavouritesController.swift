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


