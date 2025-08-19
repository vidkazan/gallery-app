//
//  Endpoint.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 15.08.25.
//

import Foundation

struct UnisplashEndpoint {
    static func fullPath(for endpoint: Self.Endpoints) -> String {
        return endpoint.rawValue
    }
    
    enum Endpoints: String {
        case listPhotos = "https://api.unsplash.com/photos"
    }
}
