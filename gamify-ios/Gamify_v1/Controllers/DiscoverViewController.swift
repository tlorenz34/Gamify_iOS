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
    
    @IBOutlet weak var inboxButton: UIButton!
    
    @IBOutlet weak var profileButton: UIButton!
    
    var game = [Game]()

    
    var temp_games = [Game(name: "Funniest video", id: ""), Game(name: "Best one-liner", id: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

    }
    
    @IBAction func unwindToDiscover(_ sender: UIStoryboardSegue){}
    
    
    func loadData() {
        
        let db = Firestore.firestore()
        db.collection("game").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                
                    var label = document.get("gameName") as! String

                    //print("\(document.documentID) => \(document.data())")
                    self.temp_games.append(Game(name: label, id: "\(document.documentID)"))
                }
                self.tableView.reloadData()
            }
            
        }
        
    }

}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return temp_games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell") as! DiscoverTableViewCell
        
        let temp_GamesModel = temp_games[indexPath.row]
        
        cell.configure(with: temp_GamesModel)
        
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     
        let game = temp_games[indexPath.row]
        performSegue(withIdentifier: "MainFeedSegue", sender: game)
        
    }
    
    
}
