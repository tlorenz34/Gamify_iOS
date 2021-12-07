//
//  SplashViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 11/7/21.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.startAnimating()
    }
    override func viewWillDisappear(_ animated: Bool) {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
    


}
