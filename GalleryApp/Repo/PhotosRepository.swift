//
//  PhotosRepository.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 15.08.25.
//

import Foundation


protocol PhotosRepository {
    func listPhotos(page: Int, perPage: Int) async -> Result<[Photo], HTTPClient.ResponseError>
}
