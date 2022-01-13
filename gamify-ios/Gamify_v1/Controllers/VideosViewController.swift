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


    // 1
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


    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.delegate = self

        // vc -> single VideoViewController
        // delegate -> VideosViewController (this current file)
        for (index, vc) in vcs.enumerated(){
            vc.view.tag = index
            vc.delegate = self
        }
        
        if let game = GameManager.shared.currentGame
        {
            if game.numberOfSubmissions >= 2
            {
                refreshDualsFromDb()
            }
            else
            {
                let alertController = UIAlertController(title: "No Uploads Yet", message: "Be the first to Upload!", preferredStyle: .alert)
                let uploadAction = UIAlertAction(title: "Upload", style: .default) { (action) in
                    alertController.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "toUpload", sender: self)
                }
                alertController.addAction(uploadAction)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                present(alertController, animated: true, completion: nil)
            }

        }
        else
        {
            refreshDualsFromDb()
        }
        
        /*DispatchQueue.main.async {
            self.refreshDualsFromDb()
        }*/
    
        self.scrollToPage(index: currentPageIndex)
        dataSource = self
        
        for v in view.subviews {
          if let scrollView = v as? UIScrollView {
            scrollView.delegate = self
          }
        }
    }


    func scrollToPage(index: Int){
        let lastIndex = (index == 0 ? 1: 0)
        vcs[lastIndex].player?.isMuted = true
        vcs[lastIndex].player?.pause()
        setViewControllers([vcs[index]], direction: .forward, animated: false, completion: nil)
        vcs[index].player?.isMuted = UserDefaults.standard.bool(forKey: "muted")
        vcs[index].player?.play()
    }
    
    
    // Shows the next dual (pair of videos)
    func displayNextDual(){
        self.vcs[1].player?.pause()
        self.vcs[1].player?.isMuted = true
        self.vcs[1].player?.isMuted = true
        currentDualIndex += 1
        if currentDualIndex < randomDuals.count{
            let dual = randomDuals[currentDualIndex]
            self.loadDual(dual)
        }
        else
        {
            refreshDualsFromDb()
        }
    }
    
    func loadDual(_ dual: ContentDual){
        
        self.vcs[0].load(content: dual.content1)
        self.vcs[1].load(content: dual.content2)
        self.vcs[1].player?.pause()
        self.vcs[1].player?.isMuted = true
        
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
    


    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let vc = pageViewController.viewControllers?.first{
            self.currentPageIndex = vc.view.tag
            containerDelegate?.updatedPageIndex(index: currentPageIndex)
            self.vcs[currentPageIndex].resumeVideo()
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
            

extension VideosViewController: UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("\(#function)")
        
        for vc in vcs{
            vc.pauseVideo()
        }
        
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

