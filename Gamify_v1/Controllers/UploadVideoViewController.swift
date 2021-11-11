//
//  UploadVideoViewController.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 10/5/21.
//

import UIKit
import Photos
import Foundation

class UploadVideoViewController: UIViewController {

    @IBOutlet weak var chooseVideoButton: UIButton!
    
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermissions()
    }
    
    private func checkPermissions() {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    
                } else {
                    print("do something here to handle")
                }
            })
        }
    }
    
    @IBAction func cameraRollButtonTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.mediaTypes = ["public.movie"]

        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func tappedUpload(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

}


extension UploadVideoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        checkPermissions()
        
        if let videoURL = info[.mediaURL] as? URL {
            VideoManager.shared.uploadVideo(videoUrl: videoURL) { errorMessage in
                print(errorMessage)
                picker.dismiss(animated: true, completion: nil)
                
                self.chooseVideoButton.setTitle("Ready to upload.", for: .normal)
                self.chooseVideoButton.setTitleColor(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), for: .normal)
                self.uploadButton.tintColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                let attributes: [NSAttributedString.Key : Any] = [ .font: UIFont.boldSystemFont(ofSize: 16) ]
                self.uploadButton.setTitleTextAttributes(attributes, for: .normal)
            }
        }
        
    }
}
