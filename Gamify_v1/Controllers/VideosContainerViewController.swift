//
//  VideosContainerViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 10/12/21.
//

import UIKit


protocol VideosContainerViewControllerDelegate{
    func updatedPageIndex(index: Int)

}

class VideosContainerViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var menuBarView: UIView!
    
    @IBOutlet weak var createGameButton: UIButton!
    var videosViewController: VideosViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        button1.layer.cornerRadius = button1.frame.size.width / 2.0
        button2.layer.cornerRadius = button2.frame.size.width / 2.0
        
        button2.backgroundColor = .gray
        
    
        
    }
 
    @IBAction func tappedButton(_ sender: UIButton) {
        updatedPageIndex(index: sender.tag)
        videosViewController?.scrollToPage(index: sender.tag)
    }
    
    @IBAction func tappedCreateButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toGameMode", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? VideosViewController{
            vc.containerDelegate = self
            videosViewController = vc
        }
    }
    
    
}

extension VideosContainerViewController: VideosContainerViewControllerDelegate{
    func updatedPageIndex(index: Int) {
        if index == 0{
            button1.backgroundColor = #colorLiteral(red: 0.4823529412, green: 0.3803921569, blue: 1, alpha: 1)
            button2.backgroundColor = .gray
        } else{
            button1.backgroundColor = .gray
            button2.backgroundColor = #colorLiteral(red: 0.4823529412, green: 0.3803921569, blue: 1, alpha: 1)
        }
    }
}
