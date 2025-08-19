//
//  ListPhotosResponse.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 15.08.25.
//

import Foundation

struct PhotoResponse: Codable {
    let id: String
    let slug: String
    let description: String?
    let altDescription: String?
    let urls: PhotoURLs

    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case description
        case altDescription = "alt_description"
        case urls
    }
}

struct PhotoURLs: Codable {
    let raw: String
    let full: String
    let regular: String
    let thumb: String

    enum CodingKeys: String, CodingKey {
        case raw
        case full
        case regular
        case thumb
    }
}

extension PhotoResponse {
    func toEntity() -> Photo {
        Photo(
            id: id,
            slug: slug,
            description: description,
            altDescription: altDescription,
            urls: Photo.PhotoURLs(
                raw: urls.raw,
                full: urls.full,
                regular: urls.regular,
                thumb: urls.thumb
            )
        )
    }
}
