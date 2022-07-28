//
//  SceneDelegate.swift
//  eazel-ios-assignment
//
//  Created by 김동혁 on 2022/07/27.
//

import FirebaseAuth
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        if Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        } else {
            let vc = TabBarViewController()

            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        }
    }
}
