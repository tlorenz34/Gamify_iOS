//
//  VideoManager.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 10/5/21.
//

import Foundation
import AVFoundation
import Firebase
import AVKit
import SwiftUI

class VideoManager{
    static let shared = VideoManager()
    
    let loadingIndicatorView = UIActivityIndicatorView()

    
    
    /**
     Adds a new `Content` and dismisses view controller.
     
     The function does several things linked together:
     1. Captures thumbnail of video.
     2. Uploads the thumbnail and video to Storage.
     3. Creates new `Submission` with data.
     4. Dismisses view controller.
     */
    func uploadVideo(videoUrl: URL, onSuccess: @escaping (String?) -> Void) {
        // make thumbnail from video
        ImageManager.shared.getThumbnailImageFromVideoUrl(videoURL: videoUrl) { thumbnail in
            
            guard let thumbnail = thumbnail else {
                return
            }
            // upload thumbnail
            ImageManager.shared.uploadThumbnailToStorage(image: thumbnail) { thumbnailUrl in
                guard thumbnailUrl != nil else {
                    return
                }

                // upload video
                self.uploadVideoToSubmissionsStorage(url: videoUrl) { uploadedVideoUrl in
                    guard let uploadedVideoUrl = uploadedVideoUrl  else {
                        return
                    }
                   let content = Content(
                            id: ContentManager.shared.getDocumentId(),
                            userId: UserManager.shared.currentUser.id,
                            username: UserManager.shared.currentUser.username,
                            voteCount: 0,
                            gameId: GameManager.shared.getDocumentId(),
                            gameName: GameManager.shared.currentGame.name,
                            url: uploadedVideoUrl.absoluteString,
                            type: "video")
                    ContentManager.shared.create(content: content, onSuccess: onSuccess)
                }
            }

        }
    }
        
    
    func uploadVideoToSubmissionsStorage(url: URL, completion: @escaping ((_ url: URL?) -> Void)) {
        
        var data: Data!
        do{
        data = try Data(contentsOf: url)
        } catch{
            print(error)
            return
        }
        
        let storageReference = Storage.storage().reference().child("videos").child("\(UUID().uuidString).mov")
        storageReference.putData(data, metadata: nil) { metadata, error in
           
//        storageReference.putFile(from: url, metadata: nil, completion: { (metadata, error) in
            if error == nil {
                  // You can also access to download URL after upload.
                storageReference.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                    }
                    completion(downloadURL)
                }
                
            } else {
                // if error, stop loading indicator
                print(error?.localizedDescription ?? "")
                completion(nil)
            }
        }
    }
}
