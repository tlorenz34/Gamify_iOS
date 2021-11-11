//
//  VideosViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/28/21.
//

import UIKit
import Foundation
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.delegate = self

        // vc -> single VideoViewController
        // delegate -> VideosViewController (this current file)
        for (index, vc) in vcs.enumerated(){
            vc.view.tag = index
            vc.delegate = self
        }
        
        DispatchQueue.main.async {
            self.refreshDualsFromDb()
        }
        refreshDualsFromDb()
        
        self.scrollToPage(index: currentPageIndex)
        dataSource = self
        
        for v in view.subviews {
          if let scrollView = v as? UIScrollView {
            scrollView.delegate = self
          }
        }
        
        
    }


    func scrollToPage(index: Int){
        setViewControllers([vcs[index]], direction: .forward, animated: false, completion: nil)
    }
    
    
    // Shows the next dual (pair of videos)
    func displayNextDual(){
        
        
        currentDualIndex += 1
        if currentDualIndex < randomDuals.count{
            let dual = randomDuals[currentDualIndex]
            self.loadDual(dual)
            
        }
        
        refreshDualsFromDb()
    }
    
    func loadDual(_ dual: ContentDual){
        
        self.vcs[0].load(content: dual.content1)
        self.vcs[1].load(content: dual.content2)
        
        setViewControllers([self.vcs.first!], direction: .forward, animated: false, completion: nil)
        
        self.currentPageIndex = 0
        self.vcs[currentPageIndex].resumeVideo()
        self.containerDelegate?.updatedPageIndex(index: currentPageIndex)
    }
    
    // Loads from database feed of duals
    func refreshDualsFromDb(){
        // Don't load data if we haven't reached the end
        
        if currentDualIndex < originalDuals.count && !originalDuals.isEmpty{
            return
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
        
        if UserManager.shared.currentUser == nil{
            UIApplication.shared.windows.first!.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController")
        } else{

            displayNextDual()
            
            ContentManager.shared.addVote(contentId: content.id)
        }
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

