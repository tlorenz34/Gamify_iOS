//
//  VideosViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/28/21.
//

import UIKit
import Foundation
import AVFoundation
import Firebase
/**
 [
    [v1, v2],
    [v3, v4]
 ]
 */

protocol VideosViewControllerDelegate {
    func winnerDidSelect(content: Content)

}

class VideosViewController: UIPageViewController, UIPageViewControllerDelegate {
    var vcs = [
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "VideoViewController") as VideoViewController,
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "VideoViewController") as VideoViewController
    ]
    
    var originalDuals = [ContentDual]()
    var randomDuals = [ContentDual]()
    var currentDualIndex = 0
    var containerDelegate: VideosContainerViewControllerDelegate?
    var currentPageIndex = 0
    let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var lastGame: Game?
    var content: [Content] = []

    override func viewDidAppear(_ animated: Bool) {
        self.delegate = self

        // vc -> single VideoViewController
        // delegate -> VideosViewController (this current file)
        for (index, vc) in vcs.enumerated() {
            vc.view.tag = index
            vc.delegate = self
        }
        
        if let game = GameManager.shared.currentGame {
            if game.numberOfSubmissions >= 2 {
                refreshDualsFromDb()
            } else {
                let alertController = UIAlertController(title: "Waiting...must have two players to begin.", message: "Be the first to Upload!", preferredStyle: .alert)
                let uploadAction = UIAlertAction(title: "Upload", style: .default) { (action) in
                    alertController.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "toUpload", sender: nil)
                }
                alertController.addAction(uploadAction)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                present(alertController, animated: true, completion: nil)
            }
        } else {
            refreshDualsFromDb()
        }
        
        /*DispatchQueue.main.async {
         self.refreshDualsFromDb()
         }*/

        self.scrollToPage(index: currentPageIndex)
        dataSource = self
    }


    func scrollToPage(index: Int){
        vcs[currentPageIndex].pauseVideo()
        setViewControllers([vcs[index]], direction: .forward, animated: false, completion: nil)
        currentPageIndex = index
        vcs[index].player?.isMuted = UserDefaults.standard.bool(forKey: "mute")
        vcs[index].resumeVideo()
    }
    
    
    // Shows the next dual (pair of videos)
    func displayNextDual(){
        vcs[currentPageIndex].pauseVideo()
        currentDualIndex += 1
        if currentDualIndex < randomDuals.count{
            let dual = randomDuals[currentDualIndex]
            self.loadDual(dual)
        } else {
            refreshDualsFromDb()
        }
    }
    
    func loadDual(_ dual: ContentDual){
        self.vcs[0].load(content: dual.content1)
        self.vcs[1].load(content: dual.content2)
        self.vcs[1].pauseVideo()
        
        setViewControllers([self.vcs.first!], direction: .forward, animated: false, completion: nil)
        
        self.currentPageIndex = 0
        self.vcs[currentPageIndex].resumeVideo()
        self.containerDelegate?.updatedPageIndex(index: currentPageIndex)

    }
    
    // Loads from database feed of duals
    func refreshDualsFromDb(){
        // Don't load data if we haven't reached the end
        if let game = GameManager.shared.currentGame
        {
            if currentDualIndex < originalDuals.count && !originalDuals.isEmpty && lastGame?.name == game.name{
                return
            }
            else
            {
                originalDuals = []
                self.lastGame = game
            }
        }
        
        ContentManager.shared.list(after: originalDuals.last?.content2.id) { duals in
            self.currentDualIndex = 0
            
            self.originalDuals = duals
            
            self.randomDuals = duals
            self.randomDuals.shuffle()
            
            // 3
            if let dual = self.randomDuals.first{
                
                self.loadDual(dual)
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        // Drag started
        vcs[currentPageIndex].pauseVideo()
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        // Drag ended
        if let vc = pageViewController.viewControllers?.first{
            currentPageIndex = vc.view.tag
            containerDelegate?.updatedPageIndex(index: currentPageIndex)
            vcs[currentPageIndex].player?.isMuted = UserDefaults.standard.bool(forKey: "mute")
            vcs[currentPageIndex].resumeVideo()
        }
    }
}

extension VideosViewController: UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = vcs.firstIndex(of: viewController as! VideoViewController) else {

            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {

            return nil
        }

        guard vcs.count > previousIndex else {
            return nil
        }
        
        return vcs[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcs.firstIndex(of: viewController as! VideoViewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1

        guard vcs.count != nextIndex else {
            return nil
        }

        guard vcs.count > nextIndex else {
            return nil
        }
        

        return vcs[nextIndex]
    }
    
}


extension VideosViewController : VideosViewControllerDelegate{


    func winnerDidSelect(content: Content) {
        
//        if UserManager.shared.currentUser == nil{
//            UIApplication.shared.windows.first!.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController")
//        } else{
//
//            displayNextDual()
//
//            ContentManager.shared.addVote(contentId: content.id)
//        }
        displayNextDual()
        ContentManager.shared.addVote(contentId: content.id)
    }
}


/**
 ___________________
 |  |           |   |
 |  |           | <------ VideoViewController (Content 2x)
 |  |           |   |           - delegate
 |  |           |   |
 |  |           |   | <----- VideosViewController (Container 1x)
 |  |           |   |
 |  |           |   |
 |  |           |   |
 |  |         X |   |
 |  _____________   |
________________________
 ___________________
 |  |           |   |
 |  |           |   |
 |  |           |   |
 |  |           |   |
 |  |           |   |
 |  |           |   |
 |  |           |   |
 |  |        X   |   |
 |  _____________   |
 
 
 
 
 
 */

