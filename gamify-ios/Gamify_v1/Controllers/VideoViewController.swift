//
//  VideoViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/28/21.
//

import UIKit
import AVFoundation
import Foundation
import MessageUI
import Firebase

class VideoViewController: UIViewController {

    @IBOutlet weak var voteButton: UIButton!
    
    @IBOutlet weak var joinButton: UIButton!
    
    @IBOutlet weak var aboutButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var testButton: UIButton!
    var audioPlayer = AVAudioPlayer()
    
    var content: Content?
    
    var delegate: VideosViewControllerDelegate?
    
    var player: AVPlayer?
    
    var playerLooper: AVPlayerLooper?
    
    var videoView = UIView()

    var toggleState = 0
    
    let refreshAlert = UIAlertController(title: "Do you want to report this video for inappropriate behavior (i.e., illegal activity, violence, etc.)?", message: "Let us know.", preferredStyle: UIAlertController.Style.alert)
    
    // 2
    var audio : AVAudioPlayer? {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.audioPlayer
        }
        set {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.audioPlayer = newValue
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        videoView.frame = view.frame
        
        view.addSubview(videoView)
        view.sendSubviewToBack(videoView)
        
        voteButton.layer.cornerRadius = (voteButton.frame.height/2)
        voteButton.clipsToBounds = true
        
        joinButton.layer.cornerRadius = joinButton.frame.height / 2

        loadingIndicator.startAnimating()

        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(videoDidTapped(_:) ))
//        videoView.addGestureRecognizer(tap)
//        videoView.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        player?.isMuted = true
//    }
//
//    @objc func videoDidTapped(_ tap: UITapGestureRecognizer){
//        if let player = player{
//            if  player.volume > 0{
//                player.volume = 0
//            } else{
//                player.volume = 1
//            }
//
//        }
//
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
        Crashlytics.crashlytics().log("Function: load - VideoViewController")


    }
    
    @IBAction func tappedJoinButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toUpload", sender: nil)
    }
    
    @IBAction func tappedAboutButton(_ sender: Any) {
    
        player?.pause()
        player?.isMuted = true
        performSegue(withIdentifier: "toLeaderboard", sender: nil)
        
    }
    
    @IBAction func tappedTestButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toGameModeVC", sender: self)
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
    
    
    // Report or flag content that is inappropriate
    @IBAction func tappedMoreButton(_ sender: UIButton) {
        
        present(refreshAlert, animated: true, completion: nil)

        
        refreshAlert.addAction(UIAlertAction(title: "Report", style: .default, handler: { (action: UIAlertAction!) in
            self.sendEmail()
    
        }))
        refreshAlert.addAction(UIAlertAction(title: "Block", style: .default, handler: { (action: UIAlertAction!) in
           

            UserManager.shared.block(id: self.content!.userId) { errorMessage in
                if let errorMessage = errorMessage {
                    print(errorMessage)
                    return
                }
                let alert = UIAlertController(title: "User has been blocked", message: "You won't see their content anymore.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))


                
            }
    
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["info@tourneyevents.com"])
            mail.setSubject("Inappropriate Content")
            mail.setMessageBody("Content #\(String(describing: self.content!.id))", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
            self.dismiss(animated: true, completion: nil)

        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

}
extension VideoViewController: MFMailComposeViewControllerDelegate{
    
}
