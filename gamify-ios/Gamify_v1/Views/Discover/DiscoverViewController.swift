//
//  DiscoverViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 11/29/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class DiscoverViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var discoverButton: UIButton!
    
    @IBOutlet weak var createGameButton: UIButton!
        
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var game = [Game]()
    
    let refreshAlert = UIAlertController(title: "Do you want to log out?", message: "You will not be able to vote or compete anymore.", preferredStyle: UIAlertController.Style.alert)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.prefersLargeTitles = true
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
 
    }
    
    @IBAction func unwindToDiscover(_ sender: UIStoryboardSegue){}

    
    @IBAction func tappedProfile(_ sender: UIButton) {
        performSegue(withIdentifier: "toProfile", sender: self)
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
    @IBAction func toHome(_ sender: UIButton) {
        performSegue(withIdentifier: "toMain", sender: self)
    }
    
    @IBAction func tappedCreate(_ sender: UIButton) {
        performSegue(withIdentifier: "toGameMode", sender: self)

    }
    
    func loadData() {
        
        let db = Firestore.firestore()
        db.collection("game").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                
                    let label = document.get("gameName") as! String
                    var submissions = 0
                    
                    if let subs = document.get("submissions") as? Int
                    {
                        submissions = subs
                    }
                    //print("\(document.documentID) => \(document.data())")
                    self.game.append(Game(name: label, id: "\(document.documentID)", numberOfSubmissions: submissions))
                }
                self.tableView.reloadData()
            }
            
        }
        
    }

}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return game.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell") as! DiscoverTableViewCell
        
        let temp_GamesModel = game[indexPath.row]
        
        cell.configure(with: temp_GamesModel)
        
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let game = game[indexPath.row]
        GameManager.shared.currentGame = game
        performSegue(withIdentifier: "MainFeedSegue", sender: self)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
}
