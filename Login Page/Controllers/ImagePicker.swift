//
//  ImagePicker.swift
//  Login Page
//
//  Created by Macbook on 15/12/22.
//

import Foundation
import UIKit

extension SignUpViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .savedPhotosAlbum
            present(picker, animated: true)
        }
       
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage {
            onGalleryImageAvailable(img: img)
        }
        dismiss(animated: true)
    }
   
}
