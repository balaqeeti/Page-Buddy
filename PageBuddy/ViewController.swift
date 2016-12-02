//
//  ViewController.swift
//  PageBuddy
//
//  Created by admin on 12/1/16.
//  Copyright © 2016 Jett Raines. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var wordLabel: UILabel!

    
    
    var activityIndicator:UIActivityIndicatorView!
    var stringArray: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        view.endEditing(true)
        
        let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Photo", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: "Take Photo", style: .default) { (alert) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
                
            }
            imagePickerActionSheet.addAction(cameraButton)
            
            let libraryButton = UIAlertAction(title: "Choose Existing", style: .default) { (alert) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            imagePickerActionSheet.addAction(libraryButton)
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (alert) -> Void in
            }
            imagePickerActionSheet.addAction(cancelButton)
            
            present(imagePickerActionSheet, animated: true, completion: nil)
        }

    }
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        return scaledImage!
    }
    
    func performImageRecognition (image: UIImage) {
        
        let tesseract = G8Tesseract()
        
        tesseract.language = "eng+fra"
        
        tesseract.engineMode = .tesseractCubeCombined
        
        tesseract.pageSegmentationMode = .auto
        
        tesseract.maximumRecognitionTime = 60.0
        
        tesseract.image = image.g8_blackAndWhite()
        
        tesseract.recognize()
        
        
        
        let newString = tesseract.recognizedText.replacingOccurrences(of: "\n", with: " ")
        stringArray = newString.components(separatedBy: " ")
        
        wordLabel.text = stringArray[0]
        
        
        removeActivityIndicator()
        
        
        
        
        
        
    }

    
    // Activity Indicator methods
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }

}

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let scaledImage = scaleImage(image: selectedPhoto, maxDimension: 640)
        
        addActivityIndicator()
        
        dismiss(animated: true, completion: {
            self.performImageRecognition(image: scaledImage)
        })
    }
    
}


