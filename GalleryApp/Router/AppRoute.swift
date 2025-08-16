//
//  AppRoute.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 16.08.25.
//

import Foundation

enum Route: Hashable {
    case gallery
    case detail(photo: Photo)
    case favorites
}
