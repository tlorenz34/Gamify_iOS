//
//  ProfileViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 1/13/22.
//

import UIKit
import Firebase
import AVFoundation
import AVKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var coinImage: UIImageView!
    
    @IBOutlet weak var numberOfCoinsLabel: UILabel!
    
    @IBOutlet weak var postsSectionLabel: UILabel!
    
    @IBOutlet weak var postDividerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var discoverButton: UIButton!
    
    @IBOutlet weak var createGameButton: UIButton!
    
    var mySubmissions = [Content]()
    
    var leaderboard = LeaderboardViewController()
    
    let refreshAlert = UIAlertController(title: "Do you want to log out?", message: "You will not be able to vote or compete anymore.", preferredStyle: UIAlertController.Style.alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if UserManager.shared.currentUser == nil{
            return
        }
        //let currentUser = UserManager.shared.currentUser.username
        if let currentUser = UserManager.shared.currentUser {
            if let username = currentUser.username {
                print("You're signed in.")
                usernameLabel.text = username
            } else {
                print("no one")
                numberOfCoinsLabel.text = "-"
                usernameLabel.text = "No account"

            }
        } else {
            print("You don't have an account")
            usernameLabel.text = "You don't have an account."
            numberOfCoinsLabel.text = "-"
        }
        ContentManager.shared.listCurrentUserContent { content in
            self.mySubmissions = content
            print("Content: \(content)")
            self.tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    @IBAction func tappedPlay(_ sender: UIButton) {
        let buttonPostion = sender.convert(sender.bounds.origin, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: buttonPostion) {
            let rowIndex =  indexPath.row
            if mySubmissions.indices.contains(rowIndex){
                playVideo(url: URL(string: mySubmissions[rowIndex].url!)!)
            }
        }
    }
    
    @IBAction func tappedHomeButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toMain", sender: self)

    }
    
    @IBAction func tappedDiscoverButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toDiscover", sender: self)
    }
    
    @IBAction func tappedCreateGameButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toCreate", sender: self)
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true) { vc.player?.play() }
    }
    
    @IBAction func tappedLogOut(_ sender: UIButton) {
        present(refreshAlert, animated: true, completion: nil)
        refreshAlert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: { (action: UIAlertAction!) in
            IdentityManager.shared.logout()
            self.dismiss(animated: true, completion: nil)
        
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
    }
}
extension ProfileViewController: UITableViewDelegate{
    
}
extension ProfileViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySubmissions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSubmissionCell") as! ProfileSubmissionsTableViewCell
        let mySubmissionsModel = mySubmissions[indexPath.row]
        cell.configure(content: mySubmissionsModel)
        return cell
    }
}
