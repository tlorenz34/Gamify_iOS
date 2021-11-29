//
//  GameModePageViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 11/28/21.
//

import UIKit
import Foundation
import SwiftUI

protocol GameModePageViewControllerDelegate: AnyObject{
    func setupPageController(numberOfPage: Int)
    func turnPageController(to index: Int)
}

class GameModePageViewController: UIPageViewController {
    
    weak var pageViewControllerDelagate: GameModePageViewControllerDelegate?
    
    var currentIndex = 0
    
    var pageTitle = ["Game Mode: Best Video", "Game Mode: Best Text (coming soon)"]
    var pageImages = [UIImage(systemName: "video.fill")?.withTintColor(.white), UIImage(systemName: "text.bubble.fill")?.withTintColor(.white)]
    var pageDescriptionText = ["Submit a video based on the prompt and earn points and badges by trying to stay on the leaderboard. There is no time limit.", "Submit your best one-liner based on the prompt and earn points and badges by trying to stay on the leaderboard. There is no time limit."]
    var backgroundColor : [UIColor] = [.black, .black, .black]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let firstViewController = contentViewController(at: 0) {
        setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    

        
    }
    func contentViewController(at index: Int) -> GameModeContentViewController? {
    if index < 0 || index >= pageTitle.count {
    return nil
    } else{
        let storyBoard = UIStoryboard(name: "GameMode", bundle: nil)
        if let pageContentViewController = storyBoard.instantiateViewController(withIdentifier: "GameModeContentViewController") as? GameModeContentViewController {
            pageContentViewController.image = pageImages[index]!
        pageContentViewController.subHeading = pageDescriptionText[index]
        pageContentViewController.heading = pageTitle[index]
        pageContentViewController.bgColor = backgroundColor[index]
        pageContentViewController.index = index
        self.pageViewControllerDelagate?.setupPageController(numberOfPage: 2)
        return pageContentViewController
        }
        return nil
        }
        
    }


}
extension GameModePageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if var index = (viewController as? GameModeContentViewController)?.index {
        index -= 1
        return contentViewController(at: index)
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if var index = (viewController as? GameModeContentViewController)?.index {
        index += 1
        return contentViewController(at: index)
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if let pageContentViewController = pageViewController.viewControllers?.first as? GameModeContentViewController {
    currentIndex = pageContentViewController.index
    self.pageViewControllerDelagate?.turnPageController(to: currentIndex)
        
    }
        
    }
 
    
}
