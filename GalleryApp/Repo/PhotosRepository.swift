//
//  PhotosRepository.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 15.08.25.
//

import Foundation


protocol PhotosRepository {
    func listPhotos(page: Int, perPage: Int) async throws -> Result<[Photo], Error>
}

final class UnsplashPhotosRepository: PhotosRepository {
    private let apiKey: String
    private let client: HTTPClient

    init(apiKey: String, session: HTTPClient) {
        self.apiKey = apiKey
        self.client = HTTPClient(session: .shared)
    }

    func listPhotos(page: Int, perPage: Int) async throws -> Result<[Photo], Error> {
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
