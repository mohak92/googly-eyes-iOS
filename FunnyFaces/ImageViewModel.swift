//
//  ImageViewModel.swift
//  Homework1
//
//  Created by Mohak Tamhane on 10/1/24.
//

import SwiftUI
import Vision
import OSLog

let logger = Logger() as Logger

class ImageViewModel: ObservableObject {
    @Published var errorMessages: String? = nil
    @Published var photosViewModel: PhotoPickerViewModel

    init(photosViewModel: PhotoPickerViewModel) {
        self.photosViewModel = photosViewModel
    }

    @MainActor func detectFaces() {

        guard let image = photosViewModel.selectedPhoto else {
            DispatchQueue.main.async {
                self.errorMessages = "Could not load image"
            }
            return
        }

        guard let cgImage = image.cgImage else {
            DispatchQueue.main.async {
                self.errorMessages = "Could not convert image to cgImage"
            }
            return
        }

        let faceLandmarkRequest = VNDetectFaceLandmarksRequest { [weak self] request, error in

            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessages = error.localizedDescription
                }
                return
            }

            let faceData: [Face]? = request.results?.compactMap({ request in
                if let observation = request as? VNFaceObservation,
                   let landmark = observation.landmarks {
                    let faceBoundingBox = observation.boundingBox
                    return Face(landmarks: landmark, faceBoundBox: faceBoundingBox)
                } else {
                    DispatchQueue.main.async {
                        self?.errorMessages = "No face landmarks detected"
                    }
                }
                return nil
            })

            DispatchQueue.main.async {
                self?.errorMessages = faceData?.isEmpty ?? false ? "No face landmarks detected : (" : nil
            }

            let updatedImage = image.drawEyes(faceData: faceData)

            DispatchQueue.main.async { [self] in
                self?.photosViewModel.selectedPhoto = updatedImage
            }
        }

        let faceDetectionRequest = VNDetectFaceRectanglesRequest { [weak self] request, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessages = error.localizedDescription
                }
                return
            }


            let rectangles: [CGRect] = request.results?.compactMap { request in
                guard let observation = request as? VNFaceObservation else { return nil }
                return observation.boundingBox
            } ?? []


            DispatchQueue.main.async {
                self?.errorMessages = rectangles.isEmpty ? "No faces detected : (" : nil
            }

            let updatedImage = image.drawVisionRect(visionRects: rectangles)

            DispatchQueue.main.async { [self] in
                self?.photosViewModel.selectedPhoto = updatedImage
            }
        }

#if targetEnvironment(simulator)
        faceDetectionRequest.usesCPUOnly = true
        faceLandmarkRequest.usesCPUOnly = true
#endif
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        do {
            try handler.perform([faceLandmarkRequest])
        } catch {
            DispatchQueue.main.async {
                self.errorMessages = "Failed to perform detection: \(error.localizedDescription)"
            }
        }
    }
}

