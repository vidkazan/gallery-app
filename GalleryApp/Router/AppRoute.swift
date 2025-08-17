//
//  AppRoute.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 16.08.25.
//

import Foundation

enum AppRoute: Hashable {
    case gallery
    case detail(photo: Photo)
    case favorites
}
