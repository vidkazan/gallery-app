//
//  Config.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 17.08.25.
//

import Foundation

struct AppConfig {
    static var unsplashKey: String {
        Bundle.main.object(forInfoDictionaryKey: "UNISPLASH_ACCESSKEY") as? String ?? ""
    }
}
