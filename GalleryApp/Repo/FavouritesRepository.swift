//
//  PhotosRepository.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 15.08.25.
//

import Foundation


protocol FavouritesRepository {
    func favourites() async -> Result<[Photo], Error>
}
