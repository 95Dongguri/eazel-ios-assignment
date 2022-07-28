//
//  SettingViewModel.swift
//  eazel-ios-assignment
//
//  Created by 김동혁 on 2022/07/28.
//

import FirebaseAuth

class SettingViewModel {
    
    /// 로그아웃
    func logout(_ vc: UIViewController) {
        let firebaseAuth = Auth.auth()

        do {
            try firebaseAuth.signOut()
            vc.presentingViewController?.dismiss(animated: true)
        } catch let signOutError as NSError {
            print("Error: signout \(signOutError.localizedDescription)")
        }
    }
    
    /// 유저이름 표시 라벨 업데이트
    func updateUser(_ label: UILabel) {
        guard let user = Auth.auth().currentUser?.displayName else { return }
        
        label.text = "\(user) 님 환영합니다!!"
    }
    
    /// 라이트모드 & 다크모드 변환
    func changeAppearance(_ appearanceControl: UISegmentedControl) {
        switch appearanceControl.selectedSegmentIndex {
        case 0:
            UserDefaults.standard.set("System", forKey: "Appearance")
        case 1:
            UserDefaults.standard.set("Light", forKey: "Appearance")
        case 2:
            UserDefaults.standard.set("Dark", forKey: "Appearance")
        default:
            return
        }
    }
}
