//
//  HomeTableViewController.swift
//  BoatStagram
//
//  Created by Elise El beze on 21/12/2016.
//  Copyright © 2016 Elise El beze. All rights reserved.
//

import UIKit

class BoatTableViewController: UITableViewController, ManagerDelegate {
    
    var listUrl : [String] = []
    var captations : [String] = []
    var boats : [Boat] = []
    var urlEnlargedImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "BoatStagram"

        let manager : Manager = Manager()
        manager.delegate = self
        manager.executeRequestApi()
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return boats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! BoatTableViewCell
        
        cell.boatImage?.downloadedFrom(boats[indexPath.row].url)
        cell.caption.text = boats[indexPath.row].caption
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // We get the url of the larger image
        urlEnlargedImage = boats[indexPath.row].urlFullScreen
        performSegue(withIdentifier: "segueIdentifier", sender: self)
    }
    
    
    // MARK: - Manager delegate
    func didReceiveSucess(response json : AnyObject) {
        let response = json as! NSDictionary
        
        // We parsed the json
        let tag = response["tag"] as! NSDictionary
        let top_post = tag["top_posts"] as! NSDictionary
        let nodes = top_post["nodes"] as! [NSDictionary]
        
        for node in nodes {
            let boat = Boat(responseJSON: node)
            boats.append(boat)
        }
        // Refresh the view
        self.tableView.reloadData()
    }
    
    func didReceiveError(error : NSError) {
        print(error)
    }
    
    
    // MARK: - Send url to ShowImage
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "segueIdentifier") {
            let vc = segue.destination as! DisplayBoatViewController
            vc.urlFullImage = urlEnlargedImage
        }
    }
}
