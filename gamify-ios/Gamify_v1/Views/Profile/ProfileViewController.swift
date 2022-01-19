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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if UserManager.shared.currentUser.username == nil{
            return
        }
        //let currentUser = UserManager.shared.currentUser.username
        switch UserManager.shared.currentUser.username {
        case "\(UserManager.shared.currentUser.username!)":
            print("You're signed in.")
            usernameLabel.text = "\(UserManager.shared.currentUser.username!)"
        case nil:
            print("no one")
        default:
            print("You don't have an account")
            usernameLabel.text = "You don't have an account."
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
