//
//  GalleryView.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 17.08.25.
//

import Foundation
import SwiftUI

struct PhotoCell: View {
    let photo: Photo
    let isFavorite: Bool

    var body: some View {
        AsyncImage(url: URL(string: photo.urls.thumb)) { phase in
            switch phase {
            case .empty:
                Rectangle()
                    .opacity(0.05)
                    .overlay(ProgressView())
            case .success(let img):
                img
                    .resizable()
                    .clipped()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(.rect)
            case .failure:
                Rectangle()
                    .opacity(0.05)
                    .overlay(Image(systemName: "photo")
                        .imageScale(.medium)
                    )
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 180,height: 180)
        .clipShape(.buttonBorder)
        .overlay(alignment: .bottomTrailing, content: {
            if isFavorite {
                Image(systemName: "heart.fill")
                    .padding(6)
                    .background(Color.secondary, in: Circle())
                    .padding(6)
            }
        })
    }
}
