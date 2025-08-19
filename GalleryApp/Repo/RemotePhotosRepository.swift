//
//  PhotosRepository.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 15.08.25.
//

import Foundation

final class RemotePhotosRepository: PhotosRepository {
    private let apiKey: String
    private let client: HTTPClient

    init(session: HTTPClient = HTTPClient(session: .shared)) {
        self.apiKey = AppConfig.unsplashKey
        self.client = session
    }

    func listPhotos(page: Int, perPage: Int) async -> Result<[Photo], HTTPClient.ResponseError> {
        var comps = URLComponents(string: UnisplashEndpoint.fullPath(for: .listPhotos))!
        comps.queryItems = [
            .init(name: "page", value: String(page)),
            .init(name: "per_page", value: String(perPage)),
        ]
        let result : Result<[PhotoResponse], HTTPClient.ResponseError> = await self.client.handleRequest(
            url: comps.url!,
            method: .GET,
            token: apiKey
        )
        
        switch result {
            case .success(let response):
                return .success(response.map{$0.toEntity()})
            case .failure(let error):
                return .failure(error)
        }
    }
}
