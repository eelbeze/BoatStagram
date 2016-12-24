//
//  BoatStagramTests.swift
//  BoatStagramTests
//
//  Created by Elise El beze on 21/12/2016.
//  Copyright © 2016 Elise El beze. All rights reserved.
//

import XCTest


@testable import BoatStagram


class BoatStagramTests: XCTestCase {
    
    let boatTableView = BoatTableViewController()
    let manager = Manager()
    
    let json = [
        "tag" : [
            "top_posts": [
                "nodes": [
                        [
                            "caption": "Test description",
                            "thumbnail_src" : "https://scontent-cdg2-1.cdninstagram.com/t51.2885-15/s640x640/sh0.08/e35/15624161_720843974733736_5276458247593656320_n.jpg?ig_cache_key=MTQxMTAxMjI2NTkwNjE5OTcxNg%3D%3D.2",
                            "display_src" : "https://scontent-cdg2-1.cdninstagram.com/t51.2885-15/e35/15624161_720843974733736_5276458247593656320_n.jpg?ig_cache_key=MTQxMTAxMjI2NTkwNjE5OTcxNg%3D%3D.2",
                            "id" : "12"
                        ]
                    ]
                ]
            ]
        ]
    
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.downloadsDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }


    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDidReceiveSuccess () {
        boatTableView.didReceiveSucess(response: json as AnyObject)
        XCTAssertEqual(boatTableView.boats[0].id, "12")
        XCTAssertEqual(boatTableView.boats[0].caption, "Test description")
        XCTAssertEqual(boatTableView.boats[0].url, "https://scontent-cdg2-1.cdninstagram.com/t51.2885-15/s640x640/sh0.08/e35/15624161_720843974733736_5276458247593656320_n.jpg?ig_cache_key=MTQxMTAxMjI2NTkwNjE5OTcxNg%3D%3D.2")
        XCTAssertEqual(boatTableView.boats[0].urlFullScreen, "https://scontent-cdg2-1.cdninstagram.com/t51.2885-15/e35/15624161_720843974733736_5276458247593656320_n.jpg?ig_cache_key=MTQxMTAxMjI2NTkwNjE5OTcxNg%3D%3D.2")
        
    }
    
    func testDowloadsImage () {
        boatTableView.didReceiveSucess(response: json as AnyObject)
        manager.createFolderDownloads()
        manager.writeFile(boats: boatTableView.boats)
        let filenameUrl = manager.getDocumentsDirectory().appendingPathComponent("\(boatTableView.boats[0].id).png")
        
        // Verify if the file is dowloads
        XCTAssertTrue(FileManager.default.fileExists(atPath: filenameUrl.path), "Download sucess")
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
