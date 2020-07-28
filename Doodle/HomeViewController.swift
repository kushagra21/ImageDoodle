//
//  HomeViewController.swift
//  Doodles
//
//  Created by Kushagra on 28/07/20.
//  Copyright © 2020 Kushagra Sinha. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
  
  var imagePicker = UIImagePickerController()
  var alert = UIAlertController(title: "Choose Source", message: nil, preferredStyle: .actionSheet)
  var viewController: UIViewController?
  var pickImageCallback : ((UIImage) -> ())?;
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imagePicker.delegate = self
    imagePicker.allowsEditing = false
    setUpAlert()
    
  }
  
  func setUpAlert()
  {
    let cameraAction = UIAlertAction(title: "Camera", style: .default){
      UIAlertAction in
      self.openCamera()
    }
    let galleryAction = UIAlertAction(title: "Gallery", style: .default){
      UIAlertAction in
      self.openGallery()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
      UIAlertAction in
    }
    
    alert.addAction(cameraAction)
    alert.addAction(galleryAction)
    alert.addAction(cancelAction)
  }
  
  
  @IBAction func btnPressed(_ sender: Any) {
    print("button pressed")
    pickImage(self) { (selectedImage) in
      print("Selected Image  :", selectedImage)
      let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
      let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DoodleViewController") as! DoodleViewController
      nextViewController.modalPresentationStyle = .fullScreen
      nextViewController.selectedImage = selectedImage
      self.present(nextViewController, animated:true, completion:nil)
    }
  }
  
  
  
  func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
    pickImageCallback = callback;
    self.viewController = viewController;
    
    
    //        alert.popoverPresentationController?.sourceView = self.viewController!.view
    viewController.present(alert, animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.originalImage] as? UIImage else {
      fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
    }
    
    //      picker.dismiss(animated: true, completion: nil)
    
    picker.dismiss(animated: true, completion: { () -> Void in
      self.pickImageCallback?(image)
    })
    
  }
  
  func openCamera(){
    alert.dismiss(animated: true, completion: nil)
    if(UIImagePickerController .isSourceTypeAvailable(.camera)){
      imagePicker.sourceType = .camera
      self.viewController!.present(imagePicker, animated: true, completion: nil)
    } else {
      let alertWarning = UIAlertController(title: "Error", message: "It seems your device doesn't have a camera", preferredStyle: .actionSheet)
      let cancelAction = UIAlertAction(title: "Okay", style: .cancel){
        UIAlertAction in
      }
      alertWarning.addAction(cancelAction)
      viewController!.present(alertWarning, animated: true, completion: nil)
    }
  }
  func openGallery(){
    alert.dismiss(animated: true, completion: nil)
    imagePicker.sourceType = .savedPhotosAlbum
    self.viewController!.present(imagePicker, animated: true, completion: nil)
  }
  
  
}


