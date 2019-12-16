//
//  ViewController.swift
//  NetworkDemo_1
//
//  Created by Admin on 12.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    private let url = "https://4kwallpaper.org/wp-content/uploads/Apple-IPhone-8-Wallpapers-39.jpg"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /* GESTURE SUPPORT
    var gestureRecognizer = UITapGestureRecognizer()
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        
        /* GESTURE SUPPORT
         
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.addTarget(self, action: #selector(tapHandler(_:)))
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gestureRecognizer)
        */
        
        downloadImage()
    }
    
    /* GESTURE SUPPORT
     
     @objc private func tapHandler(_ tapRecognizer: UIGestureRecognizer) {
        downloadImage()
    }*/
    
    private func downloadImage() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        NetworkManager.downloadImage(url) { (image) in
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.imageView.image = image
            }
        }
    }
}
