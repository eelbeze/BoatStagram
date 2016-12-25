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
    

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        boatTableView.didReceiveSucess(response: json as AnyObject)

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDidReceiveSuccess () {
        XCTAssertEqual(boatTableView.boats[0].id, "12")
        XCTAssertEqual(boatTableView.boats[0].caption, "Test description")
        XCTAssertEqual(boatTableView.boats[0].url, "https://scontent-cdg2-1.cdninstagram.com/t51.2885-15/s640x640/sh0.08/e35/15624161_720843974733736_5276458247593656320_n.jpg?ig_cache_key=MTQxMTAxMjI2NTkwNjE5OTcxNg%3D%3D.2")
        XCTAssertEqual(boatTableView.boats[0].urlFullScreen, "https://scontent-cdg2-1.cdninstagram.com/t51.2885-15/e35/15624161_720843974733736_5276458247593656320_n.jpg?ig_cache_key=MTQxMTAxMjI2NTkwNjE5OTcxNg%3D%3D.2")
        
    }
    
    func testDowloadsImage () {
        manager.createFolderDownloads()
        let _ = manager.writeFile(boats: boatTableView.boats)
        let filenameUrl = manager.getDocumentsDirectory().appendingPathComponent("\(boatTableView.boats[0].id).png")
        
        // Verify if the file is dowloads
        XCTAssertTrue(FileManager.default.fileExists(atPath: filenameUrl.path), "Download sucess")
        
        // Test if we get an image
        let image = manager.getImageWithId(id: boatTableView.boats[0].id)
        XCTAssertNotNil(image)
    }
    
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
