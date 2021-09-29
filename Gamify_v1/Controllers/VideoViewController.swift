//
//  VideoViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/28/21.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {

    var url: String!
    
    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let videoView = UIView()
        videoView.frame = view.frame
        
        let videoURL = URL(string: url)
        player = AVPlayer(url: videoURL!)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)
        
        view.addSubview(videoView)
        view.sendSubviewToBack(videoView)
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
    }
    


}
