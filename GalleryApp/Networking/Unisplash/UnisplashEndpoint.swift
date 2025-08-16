//
//  Endpoint.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 15.08.25.
//

import Foundation

struct UnisplashEndpoint {
    static func fullPath(for: Self.Endpoints) -> String {
        return Self.Endpoints.RawValue()
    }
    
    enum Endpoints: String {
        case listPhotos = "https://api.unsplash.com/photos"
    }
}
