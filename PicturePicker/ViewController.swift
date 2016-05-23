//
//  ViewController.swift
//  PicturePicker
//
//  Created by Maxim on 21.05.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit
import CoreImage
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageLoaded: UIImage?
    var finalImage: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
       
        if let pickedInfo = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = pickedInfo
            imageView.contentMode = .ScaleAspectFit
            imageLoaded = pickedInfo
        }
        
         dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func pickAnImage(sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary // указал явно, но можно и не указывать, если подразумевается только Photolibrary, как источник
        imagePicker.allowsEditing = true
        
        presentViewController(imagePicker, animated: false, completion: nil)
        
    }
    
    @IBAction func sliderMoved(sender: UISlider) {
        
        
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CIColorControls")
        
        let ciImageLoaded = CIImage(CGImage: (self.imageLoaded?.CGImage)!)
        filter?.setValue(ciImageLoaded, forKey: kCIInputImageKey)
        filter?.setValue(NSNumber(float: sender.value), forKey: kCIInputBrightnessKey)
        let cgImage = context.createCGImage((filter?.outputImage)!, fromRect: (filter?.outputImage?.extent)!)
        finalImage = UIImage(CGImage: cgImage)
        
        imageView.image = finalImage
        
    }
    
    @IBAction func saveImageToPhotoLibrary(sender: UIButton) {
        if let savedImage = finalImage {
            UIImageWriteToSavedPhotosAlbum(savedImage, self, #selector(self.savingErrorFunc), nil)
            
        } else {
            let controller = UIAlertController(title: "Фото не выбрано!", message: nil, preferredStyle: .Alert)
            let action = UIAlertAction(title: "ВЫБРАТЬ ФОТО", style: .Default, handler: nil)
            controller.addAction(action)
            presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func savingErrorFunc(image: UIImage!, didFinishSavingWithError error: NSError?, contextInfo: AnyObject?) {
        if error != nil {
            print ("Error saving photo")
        } else {
            print ("Image saved")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        slider.minimumValue = -0.2
        slider.maximumValue = 0.2
        slider.value = 0.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

