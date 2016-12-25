//
//  Manager.swift
//  BoatStagram
//
//  Created by Elise El beze on 21/12/2016.
//  Copyright © 2016 Elise El beze. All rights reserved.
//

import UIKit
import Alamofire

enum ManagerBoatState {
    case saved
    case unSaved
    case error
}

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
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let imagePath = documentsPath.appendingPathComponent("images")
        
        
        // If the folder doesn't exit
        if (!FileManager.default.fileExists(atPath: (imagePath?.path)!)) {
            do {
                try FileManager.default.createDirectory(atPath: imagePath!.path, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
        }
    }
    
    // return true if we have saved somethings
    func writeFile (boats: [Boat]) -> ManagerBoatState {
        var boatSate: ManagerBoatState = .unSaved
        
        for boat in boats {
            guard let boatUrl = URL(string: boat.urlFullScreen),
                let data = try? Data(contentsOf: boatUrl)
                else {
                    return .error
            }
            
            let filenameUrl = self.getDocumentsDirectory().appendingPathComponent("\(boat.id).png")
            // If the file already exist, we didn't save it
            if(!FileManager.default.fileExists(atPath: filenameUrl.path)) {
                
                try? data.write(to: filenameUrl)
                boatSate = .saved
            }
        }
        
        return boatSate
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let logsPath = documentsDirectory.appendingPathComponent("images")
        
        return logsPath
    }
    
    
    func getImageWithId(id: String) -> UIImage? {
        var image: UIImage? = nil
        let filenameUrl = self.getDocumentsDirectory().appendingPathComponent("\(id).png")
        if(FileManager.default.fileExists(atPath: filenameUrl.path)) {
            if let imageDownloads = UIImage(contentsOfFile: filenameUrl.path) {
                image = imageDownloads
            }
        }
        
        return image
    }
}
