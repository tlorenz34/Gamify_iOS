//
//  DiscoverViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 11/29/21.
//

import UIKit

class DiscoverViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var discoverButton: UIButton!
    
    @IBOutlet weak var createGameButton: UIButton!
    
    @IBOutlet weak var inboxButton: UIButton!
    
    @IBOutlet weak var profileButton: UIButton!
    
    let temp_games = [Game(name: "Funniest video"), Game(name: "Best one-liner")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func unwindToDiscover(_ sender: UIStoryboardSegue){}

}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return temp_games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let temp_GamesModel = temp_games[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell") as! DiscoverTableViewCell
        
        cell.configure(with: temp_GamesModel)
        
        return cell

    }
    
    
}
