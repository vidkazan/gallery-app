//
//  MainApPView.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 17.08.25.
//

import Foundation
import SwiftUI

struct MainAppView: View {
    @StateObject var router: Router<AppRoute>
    let viewBuilder: GalleryAppViewBuilder

    init(
        router: Router<AppRoute>,
        viewBuilder: GalleryAppViewBuilder
    ) {
        _router = StateObject(wrappedValue: router)
        self.viewBuilder = viewBuilder
    }

    var body: some View {
        NavigationStack(path: $router.paths) {
            viewBuilder.createGalleryView()
                .navigationDestination(for: AppRoute.self, destination: buildViews)
        }
    }

    @ViewBuilder
    private func buildViews(view: AppRoute) -> some View {
        switch view {
            case .gallery: viewBuilder.createGalleryView()
            case .detail(let index): viewBuilder.createDetailsView(index: index)
            case .favorites: Text("WIP")
        }
    }
}
