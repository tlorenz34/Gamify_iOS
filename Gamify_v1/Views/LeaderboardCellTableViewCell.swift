//
//  LeaderboardCellTableViewCell.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 10/12/21.
//

//import UIKit
//
//class LeaderboardCellTableViewCell: UITableViewCell {
//
//    @IBOutlet weak var positionLabel: UILabel!
//
//    @IBOutlet weak var leaderProfileImageView: UIImageView!
//
//    @IBOutlet weak var leaderUsernameLabel: UILabel!
//
//    @IBOutlet weak var leaderVotesLabel: UILabel!
//
//    @IBOutlet weak var leaderVoteBarView: UIView!
//
//    @IBOutlet var leaderButton: UIButton!
//
//
//
//    func updateUI(position: Int, content: Content){
//        positionLabel.text = "\(position + 1)."
//        leaderProfileImageView.kf.setImage(with: content.creatorProfileImageURL)
//        leaderUsernameLabel.text = content.creatorUsername
//        leaderVotesLabel.text = "\(content.votes) votes"
//        leaderButton.tag = position
//
//        //thumbnailImageView.kf.setImage(with: submission.thumbnailURL)
//    }
//    @IBOutlet weak var roundedCellView: UIView! {
//        didSet {
//            roundedCellView.layer.cornerRadius = 20
//            roundedCellView.layer.masksToBounds = true
//        }
//    }
//
//
//}
