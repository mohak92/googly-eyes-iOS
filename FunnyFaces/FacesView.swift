//
//  FacesView.swift
//  Homework1
//
//  Created by Mohak Tamhane on 10/1/24.
//

import SwiftUI
import PhotosUI

struct FacesView: View {
    @StateObject var viewModel: ImageViewModel

    var body: some View {
        VStack {
            if let image = viewModel.photosViewModel.selectedPhoto {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                HStack {
                    Button("Detect Faces") {
                        viewModel.detectFaces()
                    }
                    .padding()
                    ShareLink(item: Image(uiImage: image), preview: SharePreview("Funny face image", image: Image(uiImage: image)))
                }
                .disabled(viewModel.photosViewModel.selectedPhoto == nil)

                if let errorMessage = viewModel.errorMessages {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            } else {
                Text("No image available")
            }
        }
        .padding()
    }
}
