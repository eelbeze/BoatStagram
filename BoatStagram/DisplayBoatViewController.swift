//
//  ShowImageViewController.swift
//  BoatStagram
//
//  Created by Elise El beze on 21/12/2016.
//  Copyright © 2016 Elise El beze. All rights reserved.
//

import UIKit

class DisplayBoatViewController: UIViewController {

    @IBOutlet weak var enlargedImage: UIImageView!
    var urlFullImage: String? = nil
    var id: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We load image if we have saved it
        if (loadImageDirectory() != nil) {
            enlargedImage.image = loadImageDirectory()
        
        } else {
            if let urlFullImageNotNil = urlFullImage {
                enlargedImage.downloadedFrom(urlFullImageNotNil)
            }
        }
    }
    
    func loadImageDirectory () -> UIImage? {
        let mananger = Manager()
        if let idFullUrl = id {
            
            return mananger.getImageWithId(id: idFullUrl)
        }
        
        return nil
    }
}
