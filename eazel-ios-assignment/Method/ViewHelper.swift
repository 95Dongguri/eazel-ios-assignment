//
//  ViewHelper.swift
//  eazel-ios-assignment
//
//  Created by 김동혁 on 2022/07/27.
//

import UIKit

/// 탭 뷰 컨트롤러 보여주기
func showTabVC() {
    let tabVC = TabBarViewController()

    tabVC.modalPresentationStyle = .fullScreen
    UIApplication.shared.windows.first?.rootViewController?.show(tabVC, sender: nil)
}
