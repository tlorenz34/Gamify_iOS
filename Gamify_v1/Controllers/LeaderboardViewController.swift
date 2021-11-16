//
//  LeaderboardViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 10/12/21.
//

import UIKit
import Firebase

class LeaderboardViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var logOutButton: UITabBarItem!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    let refreshAlert = UIAlertController(title: "Do you want to log out?", message: "You will not be able to vote or compete anymore.", preferredStyle: UIAlertController.Style.alert)

    
    var topContent = [Content]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ContentManager.shared.listTopContent { content in
            self.topContent = content
            self.tableView.reloadData()
        }



      
    }
    
    @IBAction func tappedShare(_ sender: UIBarButtonItem) {
        
        let url = "https://apps.apple.com/us/app/gamify-compete-vote-join/id1590780699"
        
        let ac = UIActivityViewController(activityItems: ["Download Gamify and join the funniest video challenge. Vote on your favorite submissions to determine the winner.", url], applicationActivities: nil)
       // ac.excludedActivityTypes = [.postToFacebook]
        
        self.present(ac, animated: true)
    }
    
    // SETTINGS
    
    
    
    
    @IBAction func tappedSettings(_ sender: UIButton) {
        present(refreshAlert, animated: true, completion: nil)

        
        refreshAlert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: { (action: UIAlertAction!) in
            
            try! Auth.auth().signOut()
    
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "SignUpViewController")
                        self.present(vc, animated: false, completion: nil)
                        vc.modalPresentationStyle = .fullScreen
        

                    
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
    }
    
    
    


    

}

extension LeaderboardViewController: UITableViewDataSource{
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
