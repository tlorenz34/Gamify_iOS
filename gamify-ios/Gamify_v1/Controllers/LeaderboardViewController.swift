////
////  LeaderboardViewController.swift
////  Gamify_v1
////
////  Created by Thaddeus Lorenz on 10/12/21.
////
//
//import UIKit
//import Firebase
//
//class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//
//    @IBOutlet weak var tableView: UITableView!
//
//    @IBOutlet weak var backButton: UIBarButtonItem!
//
//    @IBOutlet weak var shareButton: UIBarButtonItem!
//
//    @IBOutlet weak var logOutButton: UITabBarItem!
//
//    @IBOutlet weak var settingsButton: UIButton!
//
//    let refreshAlert = UIAlertController(title: "Do you want to log out?", message: "You will not be able to vote or compete anymore.", preferredStyle: UIAlertController.Style.alert)
//
//
//    var topContent = [Content]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//
//        ContentManager.shared.listTopContent { content in
//            self.topContent = content
//            self.tableView.reloadData()
//        }
//
//
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        self.tableView.reloadData()
//    }
//
//    // Share game
//
//    @IBAction func tappedShare(_ sender: UIBarButtonItem) {
//
//        let url = "https://apps.apple.com/us/app/gamify-social-mini-games/id1590780699"
//
//        let ac = UIActivityViewController(activityItems: ["Hey - I have an invite to Gamify and want you to join. Here is the invite-only link to start creating mini-games with your friends.", url], applicationActivities: nil)
//       // ac.excludedActivityTypes = [.postToFacebook]
//
//        self.present(ac, animated: true)
//    }
//
//    // SETTINGS and LOG OUT
//
//
//    @IBAction func tappedSettings(_ sender: UIButton) {
//        present(refreshAlert, animated: true, completion: nil)
//
//
//        refreshAlert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: { (action: UIAlertAction!) in
//            IdentityManager.shared.logout()
//            self.dismiss(animated: true, completion: nil)
//
//        }))
//
//        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//            self.dismiss(animated: true, completion: nil)
//        }))
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return topContent.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell") as! LeaderBoardCell
//
//        let position = indexPath.row + 1
//        let content = topContent[indexPath.row]
//
//        cell.updateUI(position: position, content: content)
//
//        return cell
//    }
//
//}
//
//  LeaderboardViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 10/12/21.
//

import UIKit
import Firebase
import AVFoundation
import AVKit

class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var logOutButton: UITabBarItem!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var yourRankingLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    let refreshAlert = UIAlertController(title: "Do you want to log out?", message: "You will not be able to vote or compete anymore.", preferredStyle: UIAlertController.Style.alert)

    
    var topContent = [Content]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMultiple()


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
        
        let url = "https://apps.apple.com/us/app/gamify-social-mini-games/id1590780699"
        
        let ac = UIActivityViewController(activityItems: ["Hey - I have an invite to Gamify and want you to join. Here is the invite-only link to start creating mini-games with your friends.", url], applicationActivities: nil)
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
    


    
    @IBAction func tappedPlay(_ sender: UIButton) {
        let buttonPostion = sender.convert(sender.bounds.origin, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: buttonPostion) {
            let rowIndex =  indexPath.row
            if topContent.indices.contains(rowIndex){
                playVideo(url: URL(string: topContent[rowIndex].url!)!)
            }
        }
    }
    func getMultiple(){
        let db = Firestore.firestore()
        if let currentGame = GameManager.shared.currentGame?.name {
            db.collection("content").whereField("gameName", isEqualTo: "\(currentGame)").order(by: "voteCount", descending: true)
              .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for (index, document) in querySnapshot!.documents.enumerated() {
                        let tempIndex = (index + 1) as NSNumber
                        let usernameProper = document.get("username")
                        guard let currentUser = UserManager.shared.currentUser.username else{
                            return
                        }
                        if usernameProper as! String == "\(currentUser)"{
                            let formatter = NumberFormatter()
                            formatter.numberStyle = .ordinal
                        let first = formatter.string(from: tempIndex)!
                            self.yourRankingLabel.text = "\(first)"
                            break
                        }
                    }
                }
            }
        } else {
            self.yourRankingLabel.text = "No uploads."
        }

    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true) { vc.player?.play() }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topContent.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell") as! LeaderBoardCell
        
        let position = indexPath.row + 1
        let content = topContent[indexPath.row]
 
        
        cell.updateUI(position: position, content: content)
        print("cell number: \(indexPath.row)")
        return cell
    }

}
