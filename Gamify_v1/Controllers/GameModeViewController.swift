//
//  GameModeViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 11/28/21.
//

import UIKit

class GameModeViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    weak var gameModePageViewController: GameModePageViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let gameModeViewController = segue.destination as? GameModePageViewController {
    gameModeViewController.pageViewControllerDelagate = self
    gameModePageViewController = gameModeViewController
        
    }
        
    }
    
}

extension GameModeViewController: GameModePageViewControllerDelegate {
func setupPageController(numberOfPage: Int) {
pageControl.numberOfPages = numberOfPage
}
func turnPageController(to index: Int) {
    pageControl.currentPage = index
}
}
