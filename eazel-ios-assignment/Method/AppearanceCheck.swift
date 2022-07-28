//
//  AppearanceCheck.swift
//  eazel-ios-assignment
//
//  Created by 김동혁 on 2022/07/27.
//

import UIKit

func AppearanceCheck(_ viewController: UIViewController) {
    guard let appearance = UserDefaults.standard.string(forKey: "Appearance") else { return }

    if appearance == "Dark" {
        viewController.overrideUserInterfaceStyle = .dark
        viewController.view.backgroundColor = .systemBackground
        viewController.navigationController?.navigationBar.barStyle = .black
        viewController.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.white]
    } else if appearance == "Light" {
        viewController.overrideUserInterfaceStyle = .light
        viewController.view.backgroundColor = .systemBackground
        viewController.navigationController?.navigationBar.barStyle = .default
        viewController.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.black]
    }

    if #available(iOS 13.0, *) {
        if appearance == "Dark" {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .darkContent
        }
    } else {
        UIApplication.shared.statusBarStyle = .default
    }
}
