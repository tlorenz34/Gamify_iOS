//
//  VideosViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/28/21.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.delegate = self

        // vc -> single VideoViewController
        // delegate -> VideosViewController (this current file)
        for (index, vc) in vcs.enumerated(){
            vc.view.tag = index
            vc.delegate = self
        }
        
        
        refreshDualsFromDb()
        
        self.scrollToPage(index: 0)
        dataSource = self
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
        
        self.containerDelegate?.updatedPageIndex(index: 0)
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
    
//
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
//      {
//        setupPageControl()
//        return vcs.count.self
//      }
//
//      func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
//      {
//        return currentDualIndex
//      }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let vc = pageViewController.viewControllers?.first{
            containerDelegate?.updatedPageIndex(index: vc.view.tag)
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
        displayNextDual()
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
