//
//  ViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/20/21.
//

import UIKit
import Foundation
import Firebase


class VideoFeedViewController: UIViewController{
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    

    
    
    var generalArray: [UIImage] = [
        
        #imageLiteral(resourceName: "photo2"),
        #imageLiteral(resourceName: "photo1"),
        #imageLiteral(resourceName: "photo3")
    
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "SubmissionCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SubmissionCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isPagingEnabled = true
        
       
    }
    

 
}

extension VideoFeedViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
    
}


extension VideoFeedViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return generalArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubmissionCell", for: indexPath) as! SubmissionCell
        cell.myImageView.image = generalArray[indexPath.row]
        
        return cell
    }
    
}
