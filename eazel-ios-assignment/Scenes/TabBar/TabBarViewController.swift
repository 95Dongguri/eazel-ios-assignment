//
//  TabBarViewController.swift
//  eazel-ios-assignment
//
//  Created by κΉλν on 2022/07/27.
//

import FirebaseAuth
import FirebaseDatabase
import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppearanceCheck(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = .darkText
        
        let tabBarViewController: [UIViewController] = TabBarItem.allCases
            .map { tabCase in
                let vc = tabCase.viewController
                vc.tabBarItem = UITabBarItem(title: tabCase.title, image: tabCase.icon.default, selectedImage: tabCase.icon.selected)
                
                return vc
            }
        
        self.viewControllers = tabBarViewController
    }
}
