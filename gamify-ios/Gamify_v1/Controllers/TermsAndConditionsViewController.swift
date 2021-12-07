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
        
        let url = URL(string: "https://c95ef743-c3e0-4ebb-889a-5e3290022099.filesusr.com/ugd/20dff4_f0a4cb9edd174dd68cbc62c963eaec5d.pdf")!
        webView.load(URLRequest(url: url))
    }
        
    


}
