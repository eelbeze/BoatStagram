//
//  HomeTableViewController.swift
//  BoatStagram
//
//  Created by Elise El beze on 21/12/2016.
//  Copyright © 2016 Elise El beze. All rights reserved.
//

import UIKit
import UserNotifications

class BoatTableViewController: UITableViewController, ManagerDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var saveButtonItem: UIBarButtonItem!
    
    var listUrl : [String] = []
    var captations : [String] = []
    var boats : [Boat] = []
    var urlEnlargedImage: String = ""
    var uiRefreshControl: UIRefreshControl = UIRefreshControl()
    
    let urlApi = "https://www.instagram.com/explore/tags/boat/?__a=1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "BoatStagram"
        
        uiRefreshControl.addTarget(self, action: #selector(BoatTableViewController.refreshData), for: .valueChanged)
        self.tableView.addSubview(uiRefreshControl)
        
        asyncRequestApi()
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
            // If boat already exist, we continue the loop
            if !boats.contains(where: { $0.id == boat.id }) {
                boats.append(boat)
            }
        }
        
        // Refresh the view
        self.tableView.reloadData()
    }
    
    func didReceiveError(error : NSError) {
        print(error)
    }
    
    
    // MARK: - NOTIFICATION AND DELEGATES
    func sendLocalNotification () {
        // Create content of notification :
        let content = UNMutableNotificationContent()
        content.title = "Hey !"
        content.body = "All images downloaded"
        
        let requestIdentifier = "boatDowloads"
        let resquest = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(resquest, withCompletionHandler: nil)
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }
    
    // Delegate, display a notif even if the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        
        completionHandler([.alert])
    }
    
    
    //MARK: - Action
    @IBAction func saveOnTap(_ sender: Any) {
        let manager: Manager = Manager()
        saveButtonItem.isEnabled = false
        
        // Create dowloads folder
        manager.createFolderDownloads()
        
        // Save image in document folder
        DispatchQueue.global(qos: .background).async {
            manager.writeFile(boats: self.boats)
            
            DispatchQueue.main.sync {
                self.saveButtonItem.isEnabled = true
                
                // Then we send notification when the download is finished
                self.sendLocalNotification()
            }
        }
    }
    
    func refreshData () {
        asyncRequestApi()
    
        uiRefreshControl.endRefreshing()
    }
    
    
    // MARK : - Helper
    func asyncRequestApi () {
        let manager = Manager()
        manager.delegate = self
        manager.executeRequestApi(url: urlApi)
    }
    
    
    // MARK: - Send url to ShowImage
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "segueIdentifier") {
            let vc = segue.destination as! DisplayBoatViewController
            vc.urlFullImage = urlEnlargedImage
        }
    }
}
