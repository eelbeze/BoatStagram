//
//  Boat.swift
//  BoatStagram
//
//  Created by Elise El beze on 21/12/2016.
//  Copyright © 2016 Elise El beze. All rights reserved.
//

import UIKit

class Boat {
    let url: String
    let caption: String
    let urlFullScreen: String
    
    init(url: String, caption: String, urlFullScreen: String) {
        self.url = url
        self.caption = caption
        self.urlFullScreen = urlFullScreen
    }
    
    init(responseJSON: NSDictionary) {
        let reponse = responseJSON
        self.caption = reponse["caption"] as! String
        self.url = reponse["thumbnail_src"] as! String
        self.urlFullScreen = reponse["display_src"] as! String
    }

}
