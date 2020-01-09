//
//  ImagePicker.swift
//  Challenge13-15
//
//  Created by Thai Nguyen on 12/31/19.
//  Copyright © 2019 Thai Nguyen. All rights reserved.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    
    @Environment(\.presentationMode) var presentationMode
    
    typealias UIViewControllerType = UIImagePickerController
    
    
    func updateUIViewController(_ uiViewController: ImagePicker.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> ImagePicker.UIViewControllerType {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let selectedImage = info[.originalImage] as? UIImage {
                self.parent.image = selectedImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.image = nil
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
