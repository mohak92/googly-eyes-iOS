//
//  CameraPicker.swift
//  Homework1
//
//  Created by Mohak Tamhane on 10/1/24.
//

import SwiftUI
import UIKit

// The CameraPicker struct allows integration of the UIImagePickerController into SwiftUI for capturing photos.
struct CameraPicker: UIViewControllerRepresentable {
    // The Coordinator class acts as the delegate for UIImagePickerController and UINavigationController.
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        // A reference to the parent CameraPicker struct.
        var parent: CameraPicker
        
        // Initializer to set up the coordinator with a reference to the parent.
        init(parent: CameraPicker) {
            self.parent = parent
        }
        
        // This method is called when the user selects an image from the camera.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Dismiss the image picker after an image has been selected.
            picker.dismiss(animated: true, completion: nil)
            
            // Safely unwrap the original image selected by the user.
            if let uiImage = info[.originalImage] as? UIImage {
                // Update the parent’s selectedImage binding with the captured image.
                parent.selectedImage = uiImage
            }
        }
        
        // This method is called when the user cancels the image picking operation.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // Dismiss the image picker when the user cancels.
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    // A binding to the selectedImage, allowing the parent view to update when an image is captured.
    @Binding var selectedImage: UIImage?
    
    // This method creates an instance of the Coordinator class, linking it with the CameraPicker.
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // This method creates and configures the UIImagePickerController.
    func makeUIViewController(context: Context) -> UIImagePickerController {
        // Create an instance of UIImagePickerController.
        let picker = UIImagePickerController()
        
        // Set the coordinator as the delegate to handle image picking and navigation events.
        picker.delegate = context.coordinator
        
        // Set the source type to the camera, so the image picker uses the device's camera.
        picker.sourceType = .camera
        
        return picker
    }
    
    // This method allows for updates to the UIImagePickerController, but is not used in this case.
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No updates are needed for this view controller in this example.
    }
}
