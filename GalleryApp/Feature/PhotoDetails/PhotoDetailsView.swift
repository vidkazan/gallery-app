//
//  PhotoDetailsView.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 17.08.25.
//

import Foundation
import SwiftUI
import CachedAsyncImage

struct PhotoDetailView: View {
    @StateObject private var vm: DetailViewModel
    init(viewModel: @autoclosure @escaping () -> DetailViewModel) {
        _vm = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        VStack(spacing: 0) {
            if vm.photos.isEmpty {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                TabView(selection: $vm.index) {
                    ForEach(
                        Array(vm.photos.enumerated()), id: \.offset
                    ) { index,photo in
                        ZStack(alignment: .center) {
                            Color.clear.ignoresSafeArea()
                            CachedAsyncImage(url: URL(string: photo.urls.regular), transaction: Transaction(animation: .default)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    self.image(image: image, photo: photo)
                                case .failure:
                                    Image(systemName: "photo")
                                        .imageScale(.large)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .padding()
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -40 {
                                vm.goNext()
                            }
                            if value.translation.width > 40 {
                                vm.goPrev()
                            }
                        }
                )
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension PhotoDetailView {
    func image(image: Image, photo: Photo) -> some View {
        image
            .resizable()
            .scaledToFit()
            .cornerRadius(15)
            .overlay {
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    HStack {
                        Text(photo.description ?? "Photo")
                            .bold()
                            .lineLimit(1)
                            .foregroundStyle(.primary)
                        Spacer()
                        FavouritesButton(active: vm.isFavorite(photo.identifier)) {
                            vm.toggleFavorite(photo.identifier)
                        }
                    }
                    if !photo.slug.isEmpty {
                        Text(photo.slug)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }
                .padding()
                .background {
                    LinearGradient(gradient: .init(colors: [.white.opacity(0.6),.clear]), startPoint: .bottom, endPoint: .center)
                }
            }
    }
}
