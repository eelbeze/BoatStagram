//
//  Manager.swift
//  BoatStagram
//
//  Created by Elise El beze on 21/12/2016.
//  Copyright © 2016 Elise El beze. All rights reserved.
//

import UIKit
import Alamofire

protocol ManagerDelegate : class {
    func didReceiveSucess(response : AnyObject)
    func didReceiveError(error : NSError)
}

class Manager: NSObject {
    weak var delegate: ManagerDelegate?
    var url: String?
    
    func executeRequestApi (url : String) {
        Alamofire.request(url).responseJSON { (response) in
            // Check if it's a sucess
            if response.result.isSuccess {
                
                guard let value : AnyObject = response.result.value as AnyObject?
                    else {
                        print("Value is empty")
                        return
                }
                if let delegate = self.delegate {
                    delegate.didReceiveSucess(response: value)
                }
                
            } else {
                guard let error : NSError = response.result.error as NSError?
                    else{
                        print("error is empty")
                        return
                }
                
                if let delegate = self.delegate {
                    delegate.didReceiveError(error: error)
                }
            }
        }
    }
    
    
    // MARK: - Dowloads images
    func createFolderDownloads() {
        let documentsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        
        try? FileManager.default.createDirectory(atPath: documentsDirectory.path, withIntermediateDirectories: false, attributes: nil)
    }
    
    func writeFile (boats: [Boat]) {
        for boat in boats {
            guard let boatUrl = URL(string: boat.urlFullScreen),
                let data = try? Data(contentsOf: boatUrl)
                else {
                    return
            }
            
            let filenameUrl = self.getDocumentsDirectory().appendingPathComponent("\(boat.id).png")
            // If the file already exist, we didn't save it
            if(!FileManager.default.fileExists(atPath: filenameUrl.path)) {
                
                try? data.write(to: filenameUrl)
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    
}
