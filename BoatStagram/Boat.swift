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
    
    init(url: String, caption: String) {
        self.url = url
        self.caption = caption
    }
    
    init(responseJSON: NSDictionary) {
        let tabDico = responseJSON
        self.caption = tabDico["caption"] as! String
        self.url = tabDico["thumbnail_src"] as! String
    }

}
