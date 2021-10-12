//
//  ImageManager.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 10/5/21.
//

import UIKit
import AVFoundation
import Firebase

class ImageManager{
    static let shared = ImageManager()
    
    func getThumbnailImageFromVideoUrl(videoURL: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: videoURL)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumnailTime = CMTimeMake(value: 1, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    
    func uploadThumbnailToStorage(image: UIImage, completion: @escaping ((_ url: URL?) -> Void)) {
        guard let imageData: Data = image.jpegData(compressionQuality: 0.7) else {
            return
        }

        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"

        let storageRef = Storage.storage().reference().child("video-thumbnails").child(UUID().uuidString)

        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }

            storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
                completion(url)
            })
        }
    }
    
    
}
