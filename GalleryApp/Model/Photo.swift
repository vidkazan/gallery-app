//
//  Photo.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 16.08.25.
//

import Foundation

struct Photo: Codable, Hashable, Identifiable{
    var id = UUID()
    let identifier: String
    let slug: String
    let description: String?
    let altDescription: String?
    let urls: Self.PhotoURLs

    init(id: String, slug: String, description: String?, altDescription: String?, urls: Self.PhotoURLs) {
        self.identifier = id
        self.slug = slug
        self.description = description
        self.altDescription = altDescription
        self.urls = urls
    }
    
    struct PhotoURLs: Codable,Hashable {
        let raw: String?
        let full: String
        let regular: String
        let thumb: String
    }
}
