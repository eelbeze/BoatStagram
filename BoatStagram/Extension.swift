//
//  Extension.swift
//  BoatStagram
//
//  Created by Elise El beze on 21/12/2016.
//  Copyright © 2016 Elise El beze. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadedFrom(_ link:String) {
        if let url = URL(string: link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async(execute: {
                    self.image = UIImage(data: data)
                })
            }).resume()
            
        }
    }
}

