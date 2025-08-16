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
    let createdAt: Date
    let updatedAt: Date
    let width: Int
    let height: Int
    let color: String
    let description: String?
    let altDescription: String?
    let urls: PhotoURLs

    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width
        case height
        case color
        case description
        case altDescription = "alt_description"
        case urls
    }
}

struct PhotoURLs: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
    let smallS3: String

    enum CodingKeys: String, CodingKey {
        case raw
        case full
        case regular
        case small
        case thumb
        case smallS3 = "small_s3"
    }
}

extension PhotoResponse {
    func toEntity() -> Photo {
        Photo(
            id: id,
            slug: slug,
            createdAt: createdAt,
            updatedAt: updatedAt,
            width: width,
            height: height,
            color: color,
            description: description,
            altDescription: altDescription,
            urls: Photo.PhotoURLs(
                raw: urls.raw,
                full: urls.full,
                regular: urls.regular,
                small: urls.small,
                thumb: urls.thumb,
                smallS3: urls.smallS3
            )
        )
    }
}
