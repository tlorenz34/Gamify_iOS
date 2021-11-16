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
    
    @IBOutlet weak var aboutButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var audioPlayer = AVAudioPlayer()

    
    var content: Content?
    
    var delegate: VideosViewControllerDelegate?
    
    var player: AVPlayer?
    
    var playerLooper: AVPlayerLooper?
    
    var videoView = UIView()
    

    var toggleState = 0
    
    // 2
    override func viewDidLoad() {
        super.viewDidLoad()

        videoView.frame = view.frame
        
        view.addSubview(videoView)
        view.sendSubviewToBack(videoView)
        
        voteButton.layer.cornerRadius = (voteButton.frame.height/2)
        voteButton.clipsToBounds = true
        
        joinButton.layer.cornerRadius = joinButton.frame.height / 2

        loadingIndicator.startAnimating()
        

        // Do any additional setup after loading the view.
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        player?.isMuted = true
//    }



    
    func load(content: Content){
        self.content = content
        let playerItem = AVPlayerItem(url: URL(string: content.url!)!)
        self.player = AVQueuePlayer(items: [playerItem])
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)
        playerLooper = AVPlayerLooper(player: player! as! AVQueuePlayer, templateItem: playerItem)
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        player?.replaceCurrentItem(with: playerItem)
        

    }
    
    @IBAction func tappedJoinButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toUpload", sender: nil)

    }
    
    @IBAction func tappedAboutButton(_ sender: Any) {
    
        player?.pause()
        player?.isMuted = true
        performSegue(withIdentifier: "toLeaderboard", sender: nil)
        
    }
    
    @IBAction func unwindToOne(_ sender: UIStoryboardSegue){}
    
    
    func pauseVideo(){
        player?.pause()
    }
    
    func resumeVideo(){
        player?.play()
    }
    
    
    @IBAction func voteButtonTapped(_ sender: UIButton) {
    
        let ANIMATION_DURATION = 1.2
        
        let impactMed = UIImpactFeedbackGenerator(style: .soft)
        impactMed.impactOccurred()
        let pulse = PulseAnimation(numberOfPulse: 1.0, radius: 1000, postion: sender.center)
        pulse.animationDuration = ANIMATION_DURATION
        pulse.backgroundColor =  #colorLiteral(red: 0.4823529412, green: 0.3803921569, blue: 1, alpha: 1)
        self.view.layer.insertSublayer(pulse, below: self.view.layer)
        self.player?.isMuted = true
        DispatchQueue.main.asyncAfter(deadline: .now() + ANIMATION_DURATION) {
            self.delegate?.winnerDidSelect(content: self.content!)
        }
        
    }
        
      
    


}
