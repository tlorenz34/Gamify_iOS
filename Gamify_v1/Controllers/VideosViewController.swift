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

class VideosViewController: UIPageViewController {
    
    // 1
    var vcs = [
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "VideoViewController") as VideoViewController,
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "VideoViewController") as VideoViewController
    ]
    
    var duals = [ContentDual]()
    
    var currentDualIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for vc in vcs{
            
        }
        
        ContentManager.shared.list { duals in
            // 3
            if let dual = duals.first{
                self.vcs[0].load(content: dual.content1)
                self.vcs[1].load(content: dual.content2)
            }
           
        }
        
        setViewControllers([self.vcs.first!], direction: .forward, animated: false, completion: nil)


        dataSource = self
        // Do any additional setup after loading the view.
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
        
        currentDualIndex += 1
        if currentDualIndex < duals.count{
            
            let dual = duals[currentDualIndex]
            self.vcs[0].load(content: dual.content1)
            self.vcs[1].load(content: dual.content2)
            
            setViewControllers([self.vcs.first!], direction: .forward, animated: false, completion: nil)
        }
       
    }
}
