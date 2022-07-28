//
//  ViewHelper.swift
//  eazel-ios-assignment
//
//  Created by 김동혁 on 2022/07/27.
//

import UIKit

func showTabVC() {
    let tabVC = TabBarViewController()

    tabVC.modalPresentationStyle = .fullScreen
    UIApplication.shared.windows.first?.rootViewController?.show(tabVC, sender: nil)
}
