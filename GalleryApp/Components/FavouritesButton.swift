//
//  FavouritesButton.swift
//  GalleryApp
//
//  Created by Dmitrii Grigorev on 18.08.25.
//

import Foundation
import SwiftUI

struct FavouritesButton: View {
    var active: Bool
    
    let action: () -> ()
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Image(systemName: self.active ? "heart.fill" : "heart")
                .foregroundStyle(.white)
                .imageScale(.large)
                .padding(8)
        }
        .buttonStyle(.plain)
    }
}
