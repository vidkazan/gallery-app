//
//  Endpoint.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 15.08.25.
//

import Foundation

struct UnisplashEndpoint {
    static let endpoint = "https://api.unsplash.com/"
    static let listPostsPath = "photos/"
    
    static var fullPath: String {
        return "\(endpoint)\(listPostsPath)"
    }
}
