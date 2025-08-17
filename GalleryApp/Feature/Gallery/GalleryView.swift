//
//  GalleryView.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 17.08.25.
//

import Foundation
import SwiftUI

struct GalleryView: View {
    @StateObject private var vm: GalleryViewModel

    private let columns = [GridItem(.adaptive(minimum: 140),spacing: 6)]

    init(viewModel: @autoclosure @escaping () -> GalleryViewModel) {
        _vm = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(vm.photos) { photo in
                    PhotoCell(
                        photo: photo,
                        isFavorite: vm.isFavorite(photo.identifier)
                    )
                    .onAppear { Task {
                            await vm.loadMoreIfNeeded(currentItem: photo)
                    }}
                    .onTapGesture {
                        vm.pushToPhotoDetails(photo: photo)
                    }
                }
                if vm.isLoading {
                    ProgressView().frame(maxWidth: .infinity)
                }
            }
            .padding(8)
        }
        .navigationTitle("Gallery")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    vm.reload()
                }, label: {
                    Label("reload", systemImage: "arrow.circlepath")
                })
            })
        }
        .task {
            if vm.photos.isEmpty {
                vm.reload()
            }
        }
        .alert(
            "Error",
            isPresented: .constant(vm.error != nil),
            actions: {
                Button("OK") { vm.error = nil }
            }, message: {
                Text(vm.error ?? "")
            }
        )
    }
}

private struct PhotoCell: View {
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
                    .overlay(Image(systemName: "photo").imageScale(.large))
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 180,height: 180)
        .cornerRadius(12)
        .overlay(alignment: .bottomTrailing, content: {
            if isFavorite {
                Image(systemName: "heart.fill")
                    .padding(6)
                    .background(.ultraThinMaterial, in: Circle())
                    .padding(6)
            }
        })
    }
}
