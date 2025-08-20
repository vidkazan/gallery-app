//
//  FavouritesView.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 20.08.25.
//

import Foundation
import SwiftUI

struct FavouritesView: View {
    @StateObject private var vm: FavouritesViewModel
    
    private let columns = [GridItem(.adaptive(minimum: 140),spacing: 6)]
    
    init(viewModel: @autoclosure @escaping () -> FavouritesViewModel) {
        _vm = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(Array(vm.photos.enumerated()),id: \.element.id) { index,photo in
                    if vm.isFavorite(photo.identifier) {
                        PhotoCell(
                            photo: photo,
                            isFavorite: true
                        )
                    }
                }
            }
            .padding(8)
        }
        .navigationTitle("Favourites")
        .toolbar { toobar() }
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
    
    @ViewBuilder func toobar() -> some View {
        HStack {
            if vm.isLoading {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
