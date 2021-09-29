//
//  VideosViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/28/21.
//

import UIKit

class VideosViewController: UIPageViewController {

    let videoUrls = ("https://firebasestorage.googleapis.com/v0/b/gamify-150f4.appspot.com/o/video_1_6f8f5c8df6c544e2b191dc90223e1fb9.MP4?alt=media&token=6946fe07-0360-413e-b48a-cc6a6643357f", "https://firebasestorage.googleapis.com/v0/b/gamify-150f4.appspot.com/o/joined_video_dfbbcad7d0fb437ebdb2f7500a24025c.MP4?alt=media&token=af78ed43-642d-4420-b6db-2cc6fe70efb8")
    
    var vcs = [VideoViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let v1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "VideoViewController") as VideoViewController
        v1.url = videoUrls.0
        
        let v2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "VideoViewController") as VideoViewController
        v2.url = videoUrls.1
        
        vcs = [v1, v2]
        
        setViewControllers([v1], direction: .forward, animated: false, completion: nil)
        
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
