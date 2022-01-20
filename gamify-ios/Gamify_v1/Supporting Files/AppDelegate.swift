//
//  AppDelegate.swift
//  Gamify_v1
//
//  Created by Thaddeus Lorenz on 9/20/21.
//

import UIKit
import Firebase
import Foundation
import AVFoundation


extension Notification.Name {
    static let signOutNotification = Notification.Name("signOutNotification")
    static let signedInNotification = Notification.Name("signedInNotification")
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var handler: AuthStateDidChangeListenerHandle!
    var audioPlayer : AVAudioPlayer? = nil



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        
        handler = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user{
                UserManager.shared.loadCurrentUser(userId: user.uid)
                NotificationCenter.default.post(name: .signedInNotification, object: nil)
            } else{
                NotificationCenter.default.post(name: .signOutNotification, object: nil)
            }
            DispatchQueue.main.async {
                UIApplication.shared.windows.first!.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideosContainerViewController")
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(signOutAction(_:)), name: .signOutNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signedInAction(_:)), name: .signedInNotification, object: nil)
        
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        
        return true
    }

    @objc func signOutAction(_ notification: Notification) {
        DispatchQueue.main.async {
            UIApplication.shared.windows.first!.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController")
        }
    }
    
    @objc func signedInAction(_ notification: Notification) {
        DispatchQueue.main.async {
            UIApplication.shared.windows.first!.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideosContainerViewController")
        }
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

