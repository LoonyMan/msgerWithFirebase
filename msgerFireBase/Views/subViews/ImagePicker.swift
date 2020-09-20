//
//  ImagePicker.swift
//  msgerFireBase
//
//  Created by Mihail on 25.04.2020.
//  Copyright © 2020 loonyman. All rights reserved.
//

import SwiftUI

struct ImagePicker : UIViewControllerRepresentable {
    
    @Binding var picker : Bool
    @Binding var imageData : Data
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        
        return ImagePicker.Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
        
    }
    
    class Coordinator : NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        
        var parent : ImagePicker
        
        init(_ parent : ImagePicker) {
            
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            self.parent.picker.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            
            let image = info[.originalImage] as! UIImage
            
            let data = image.jpegData(compressionQuality: 0.45)
            
            self.parent.imageData = data!
            
            self.parent.picker.toggle()
        }
    }
}
