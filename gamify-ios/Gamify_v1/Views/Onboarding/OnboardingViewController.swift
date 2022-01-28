//
//  OnboardingViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 1/27/22.
//

import UIKit
import Lottie


class OnboardingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK:- outlets for the viewController
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var getStartedButton: UIButton!

    
    // data for the Onboarding Screens
    var pages: [Page] = []
   
    // MARK:- lifeCycle methods for the ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pages = [
            Page(animationName: "animation3", title: "Join", description: "Join public games and challenges"),
            Page(animationName: "animation2", title: "Discover", description: "Check out new games created by others"),
            Page(animationName: "castVote", title: "Vote", description: "Compare and vote on your favorite submissions"),
            Page(animationName: "animation4", title: "Create", description: "Create a public game and share with everyone"),
            Page(animationName: "coin", title: "Earn", description: "Earn coins for the number of votes that you receive")
                 ]
        
        // to make the button rounded
        self.getStartedButton.layer.cornerRadius = 20
        
        // register the custom CollectionViewCell and assign the delegates to the ViewController
        self.collectionView.backgroundColor = .white
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: OnboardingCollectionViewCell.identifier, bundle: Bundle.main),
                                     forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        // set the number of pages to the number of Onboarding Screens
        self.pageControl.numberOfPages = self.pages.count
        self.collectionView.reloadData()
    }

    
    // MARK:- outlet functions for the viewController
    @IBAction func pageChanged(_ sender: Any) {
        let pc = sender as! UIPageControl
        
        // scrolling the collectionView to the selected page
        collectionView.scrollToItem(at: IndexPath(item: pc.currentPage, section: 1),
                                    at: .centeredHorizontally, animated: true)
        
    }
    
    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
        // move the user to the other view controller
        print("Move to other view controller")
        DispatchQueue.main.async {
            UIApplication.shared.windows.first!.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideosContainerViewController")
        }
    }
    
    // MARK:- collectionView dataSource & collectionView FlowLayout delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell",
                                                      for: indexPath) as! OnboardingCollectionViewCell
        
        // function for configuring the cell, defined in the Custom cell class
        
        cell.configureCell(pages[indexPath.row])
        print(pages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    // to update the UIPageControl
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        print("CURRENT PAGE: \(pageControl.currentPage)")
    }
    
}
