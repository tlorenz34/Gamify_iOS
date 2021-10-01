//
//  VideoViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/28/21.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {

    var content: Content?
    
    var delegate: VideosViewControllerDelegate?
    
    var player: AVPlayer?
    
    var videoView = UIView()
    
    // 2
    override func viewDidLoad() {
        super.viewDidLoad()

        videoView.frame = view.frame
        
        view.addSubview(videoView)
        view.sendSubviewToBack(videoView)
        
        // Do any additional setup after loading the view.
    }
    
    func load(content: Content){
        self.content = content
        
        let videoURL = URL(string: content.url!)
        player = AVPlayer(url: videoURL!)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)
        
        player?.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }
    


}
