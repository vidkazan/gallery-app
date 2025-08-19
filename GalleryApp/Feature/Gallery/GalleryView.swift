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
                ForEach(Array(vm.photos.enumerated()),id: \.element.id) { index,photo in
                    PhotoCell(
                        photo: photo,
                        isFavorite: vm.isFavorite(photo.identifier)
                    )
                    .onAppear {
                        Task(priority: .background) {
                            await vm.loadMoreIfNeeded(currentItem: photo)
                        }
                    }
                    .onTapGesture {
                        vm.pushToPhotoDetails(index: index)
                    }
                }
            }
            .padding(8)
        }
        .navigationTitle("Gallery")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                HStack {
                    if vm.isLoading {
                        ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    Button(action: {
                        vm.pushToFavourites()
                    }, label: {
                        Label("heart", systemImage: "heart")
                    })
                    Button(action: {
                        vm.reload()
                    }, label: {
                        Label("reload", systemImage: "arrow.circlepath")
                    })
                }
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
