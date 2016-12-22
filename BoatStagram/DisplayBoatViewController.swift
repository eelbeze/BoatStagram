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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let urlFullImageNotNil = urlFullImage {
            enlargedImage.downloadedFrom(urlFullImageNotNil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
