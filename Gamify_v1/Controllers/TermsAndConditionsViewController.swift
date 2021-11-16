//
//  TermsAndConditionsViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 11/15/21.
//

import UIKit
import WebKit

class TermsAndConditionsViewController: UIViewController {
    
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var termsAndConditionsLabel: UILabel!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTermsAndConditions()

    }
    
    func loadTermsAndConditions() {
        
        let url = URL(string: "https://www.tourneyevents.com/post/tourney-competitions-contest-official-rules-rules-terms-and-conditions")!
        webView.load(URLRequest(url: url))
    }
        
    


}
