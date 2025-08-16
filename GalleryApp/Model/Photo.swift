//
//  Photo.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 16.08.25.
//

import Foundation

struct Photo: Identifiable, Hashable {
    let id: String
    let slug: String
    let createdAt: Date
    let updatedAt: Date
    let width: Int
    let height: Int
    let color: String?
    let description: String?
    let altDescription: String?
    let urls: Self.PhotoURLs

    
    struct PhotoURLs: Hashable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
        let smallS3: String
    }
}
