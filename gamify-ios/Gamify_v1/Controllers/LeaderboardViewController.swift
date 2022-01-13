//
//  LeaderboardViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 10/12/21.
//

import UIKit
import Firebase

class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var logOutButton: UITabBarItem!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    let refreshAlert = UIAlertController(title: "Do you want to log out?", message: "You will not be able to vote or compete anymore.", preferredStyle: UIAlertController.Style.alert)

    
    var topContent = [Content]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        ContentManager.shared.listTopContent { content in
            self.topContent = content
            self.tableView.reloadData()
        }


      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // Share game
    
    @IBAction func tappedShare(_ sender: UIBarButtonItem) {
        
        let url = "https://testflight.apple.com/join/mcloUhHb"
        
        let ac = UIActivityViewController(activityItems: ["Download Gamify and join the funniest video game. Vote on your favorite submissions to determine the winner.", url], applicationActivities: nil)
       // ac.excludedActivityTypes = [.postToFacebook]
        
        self.present(ac, animated: true)
    }
    
    // SETTINGS and LOG OUT

    
    @IBAction func tappedSettings(_ sender: UIButton) {
        present(refreshAlert, animated: true, completion: nil)

        
        refreshAlert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: { (action: UIAlertAction!) in
            IdentityManager.shared.logout()
            self.dismiss(animated: true, completion: nil)
        
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topContent.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell") as! LeaderBoardCell
        
        let position = indexPath.row + 1
        let content = topContent[indexPath.row]
        
        cell.updateUI(position: position, content: content)
        
        return cell
    }

}
