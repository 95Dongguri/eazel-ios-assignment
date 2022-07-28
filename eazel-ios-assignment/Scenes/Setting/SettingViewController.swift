//
//  SettingViewController.swift
//  eazel-ios-assignment
//
//  Created by 김동혁 on 2022/07/27.
//

//import FirebaseAuth
import SnapKit
import UIKit

class SettingViewController: UIViewController {
    
    let appearnceArray = ["Device", "Light", "Dark"]
    
    let viewModel = SettingViewModel()
    
    private lazy var userLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        
        return label
    }()
    
    private lazy var appearanceControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: appearnceArray)
        seg.backgroundColor = UIColor.clear
        seg.tintColor = UIColor.black
        seg.selectedSegmentIndex = 0
        
        seg.addTarget(self, action: #selector(tapAppearanceControl), for: .valueChanged)
        
        return seg
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24.0, weight: .medium)
        button.addTarget(self, action: #selector(tapLogoutButton), for: .touchUpInside)
        
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        AppearanceCheck(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
}

private extension SettingViewController {
    func setupLayout() {
        [
            userLabel,
            appearanceControl,
            logoutButton
        ].forEach {
            view.addSubview($0)
        }
        
//        guard let user = Auth.auth().currentUser?.displayName else { return }
//
//        userLabel.text = "\(user) 님 환영합니다!!"
        viewModel.updateUser(userLabel)
        
        userLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(200.0)
            $0.centerX.equalToSuperview()
        }
        
        appearanceControl.snp.makeConstraints {
            $0.top.equalTo(userLabel.snp.bottom).offset(24.0)
            $0.centerX.equalTo(userLabel)
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(appearanceControl.snp.bottom).offset(48.0)
            $0.centerX.equalTo(userLabel)
        }
    }
    
    @objc func tapLogoutButton() {
//        let firebaseAuth = Auth.auth()
//
//        do {
//            try firebaseAuth.signOut()
//            presentingViewController?.dismiss(animated: true)
//            navigationController?.popToRootViewController(animated: true)
//        } catch let signOutError as NSError {
//            print("Error: signout \(signOutError.localizedDescription)")
//        }
        viewModel.logout(self)
    }
    
    @objc func tapAppearanceControl() {
//        switch appearanceControl.selectedSegmentIndex {
//        case 0:
//            UserDefaults.standard.set("Light", forKey: "Appearance")
//        case 1:
//            UserDefaults.standard.set("Light", forKey: "Appearance")
//        case 2:
//            UserDefaults.standard.set("Dark", forKey: "Appearance")
//        default:
//            return
//        }
        viewModel.changeAppearance(appearanceControl)
        self.viewWillAppear(true)
    }
}