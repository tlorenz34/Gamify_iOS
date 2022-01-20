//
//  VideosContainerViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 10/12/21.
//

import UIKit
import Firebase

protocol VideosContainerViewControllerDelegate{
    func updatedPageIndex(index: Int)

}

class VideosContainerViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var menuBarView: UIView!
    
    @IBOutlet weak var createGameButton: UIButton!
    
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var discoverButton: UIButton!
    
    @IBOutlet weak var gameNameLabel: UILabel!
    
    @IBOutlet weak var orLabel: UILabel!
    
    
    
    
    var videosViewController: VideosViewController?
    
    var totalVotes = 0
    var tempArray = [Any]()


    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        button1.layer.cornerRadius = button1.frame.size.width / 2.0
        button2.layer.cornerRadius = button2.frame.size.width / 2.0
        
        button2.backgroundColor = .gray
        
        createGameButton.clipsToBounds = true
        
//
//        if let game = GameManager.shared.currentGame
//        {
//            gameNameLabel.text = game.name
//        }
//        else
//        {
//            GameManager.shared.firstGame = Game(name: "funniest", id: "daF18QnnvKHAIJy0IeYQ")
//            let firstGame = GameManager.shared.firstGame
//            gameNameLabel.text = firstGame!.name
//          
//            
//        }
    

    }
 
    @IBAction func tappedButton(_ sender: UIButton) {
        updatedPageIndex(index: sender.tag)
        videosViewController?.scrollToPage(index: sender.tag)
    }
    
    @IBAction func tappedCreateButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toGameMode", sender: self)
    }
    

    @IBAction func tappedDiscoverButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toDiscover", sender: self)
    }
    
    @IBAction func tappedProfileButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toProfile", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let videosVC = segue.destination as? VideosViewController {
            videosVC.containerDelegate = self
            videosViewController = videosVC
        }
    }

    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        if let videosVC = videosViewController {
            videosVC.vcs[videosVC.currentPageIndex].pauseVideo()
        }
        super.performSegue(withIdentifier: identifier, sender: sender)
    }
}

extension VideosContainerViewController: VideosContainerViewControllerDelegate{
    func updatedPageIndex(index: Int) {
        if index == 0{
            button1.backgroundColor = #colorLiteral(red: 1, green: 0.2901960784, blue: 0.3137254902, alpha: 1)
            button2.backgroundColor = .gray
        } else{
            button1.backgroundColor = .gray
            button2.backgroundColor = #colorLiteral(red: 1, green: 0.2901960784, blue: 0.3137254902, alpha: 1)
        }
    }
}
