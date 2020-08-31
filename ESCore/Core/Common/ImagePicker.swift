//
//  ImagePicker.swift
//  EslamCore
//
//  Created by Eslam on 3/9/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit

open class ImagePicker: NSObject {
    public let picker = UIImagePickerController()
    
    public var allowDeleting: Bool = false
    
    public var onPickImage: ((_ image: UIImage?)->())?
    public var onDeleteImage: (()->())?
    
    
    private weak var controller: UIViewController?
    private weak var view: UIView?
    
    
    public override init() {
        super.init()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
    }
    
    public func pickImage(from view: UIView, in controller: UIViewController, onComplete: ((_ image: UIImage?)->())?) {
        self.controller = controller
        self.view = view
        self.onPickImage = onComplete
        displayImageOptions()
    }
}

//MARK: - Helpers
extension ImagePicker {
    /// display message image options
    func displayImageOptions() {
        guard let controller = self.controller, let view = self.view else { return }
        
        let alert = UIAlertController(title: "selectImageTile".selfLocalized, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "fromGallery".selfLocalized, style: .default, handler: { [weak self] (_) in
            self?.openGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "fromCamera".selfLocalized, style: .default, handler: { [weak self] (_) in
            self?.openCamera()
        }))
        
        if allowDeleting {
            alert.addAction(UIAlertAction(title: "deleteImage".selfLocalized, style: .destructive, handler: { [weak self] (_) in
                displayConfirmationAlert(withTitle: "deleteImage".selfLocalized, andMessage: "deleteImageMessage".selfLocalized) {
                    self?.onDeleteImage?()
                }
            }))
        }
        
        alert.addAction(UIAlertAction(title: "cancel".selfLocalized, style: .cancel, handler: nil))
        
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = CGRect(x: view.center.x, y: view.center.y, width: 0, height: 0)
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    /// open photo library
    func openGallery() {
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        controller?.present(picker, animated: true, completion: nil)
    }
    
    /// open camera
    func openCamera() {
        picker.sourceType = .camera
        controller?.present(picker, animated: true, completion: nil)
    }
}

//MARK: - Image Picker Delegate
extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = (info[.editedImage] as? UIImage)?.compressed(quality: 0.6) {
            onPickImage?(image)
        }else {
            onPickImage?((info[.originalImage] as? UIImage)?.compressed(quality: 0.6))
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
