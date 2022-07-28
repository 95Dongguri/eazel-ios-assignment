//
//  TabBarItem.swift
//  eazel-ios-assignment
//
//  Created by 김동혁 on 2022/07/27.
//

import UIKit

enum TabBarItem: CaseIterable {
    case timer
    case setting
    
    var title: String {
        switch self {
        case .timer: return "스탑워치"
        case .setting: return "설정"
        }
    }
    
    var icon: (default: UIImage?, selected: UIImage?) {
        switch self {
        case .timer: return (UIImage(systemName: "stopwatch"), UIImage(systemName: "stopwatch.fill"))
        case .setting: return (UIImage(systemName: "person"), UIImage(systemName: "person.fill"))
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .timer: return TimerViewController()
        case .setting: return SettingViewController()
        }
    }
}
