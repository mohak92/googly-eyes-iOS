//
//  ContentView.swift
//  Homework1
//
//  Created by Mohak Tamhane on 10/2/24.
//

import SwiftUI
import PhotosUI

struct NavTabView: View {

    @StateObject private var photoPickerViewModel = PhotoPickerViewModel()

    var body: some View {
        NavigationView {
            TabView {
                FacesView(viewModel: ImageViewModel(photosViewModel: photoPickerViewModel))
                    .tabItem {
                        Label("Faces", systemImage: "face.smiling")
                    }
                CameraView()
                    .tabItem {
                        Label("Camera", systemImage: "camera")
                    }
            }.navigationTitle("Funny Faces")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        PhotosPicker(
                            selection: $photoPickerViewModel.imageSelection,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .imageScale(.large)
                        }
                    }
                }
        }
    }
}

#Preview {
    NavTabView()
}
