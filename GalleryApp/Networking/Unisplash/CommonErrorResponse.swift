//
//  CommonError.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 15.08.25.
//

import Foundation

struct CommonErrorResponse: Decodable {
    let errors: [String]
}
