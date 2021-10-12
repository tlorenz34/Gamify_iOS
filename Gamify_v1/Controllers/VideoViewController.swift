//
//  VideoViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/28/21.
//

import UIKit
import AVFoundation
import Foundation

class VideoViewController: UIViewController {

    @IBOutlet weak var voteButton: UIButton!
    
    @IBOutlet weak var joinButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!

    
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
        
        voteButton.layer.cornerRadius = (voteButton.frame.height/2)
        voteButton.clipsToBounds = true
        


        
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
    
    @IBAction func tappedJoinButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toUpload", sender: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
            self?.player?.play()
            self?.player?.seek(to: CMTime.zero)

        }
       // player?.play()
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.seek(to: CMTime.zero)
    }
    
    @IBAction func voteButtonTapped(_ sender: UIButton) {
    
        let impactMed = UIImpactFeedbackGenerator(style: .soft)
        impactMed.impactOccurred()
        let pulse = PulseAnimation(numberOfPulse: 1.0, radius: 120, postion: sender.center)
        pulse.animationDuration = 1.2
        pulse.backgroundColor =  #colorLiteral(red: 0, green: 0.7842717171, blue: 0.5222512484, alpha: 1)
        self.view.layer.insertSublayer(pulse, below: self.view.layer)
        delegate?.winnerDidSelect(content: content!)
        
    }
    


}
