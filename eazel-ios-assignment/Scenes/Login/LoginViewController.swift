//
//  LoginViewController.swift
//  eazel-ios-assignment
//
//  Created by 김동혁 on 2022/07/27.
//

//import FirebaseAuth
import GoogleSignIn
import SnapKit
import UIKit

class LoginViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Stop Watch"
        label.textColor = .label
        label.font = .systemFont(ofSize: 32.0, weight: .bold)
        
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("구글 로그인", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24.0, weight: .medium)
        button.addTarget(self, action: #selector(tapLoginButton), for: .touchUpInside)
        
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppearanceCheck(self)
        GIDSignIn.sharedInstance().presentingViewController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        /// 로그인 완료 체크 후 뷰 넘기는 로직
//        NotificationCenter.default.addObserver(self, selector: #selector(checkSign), name: NSNotification.Name("Login"), object: nil)
    }
}

private extension LoginViewController {
    func setupLayout() {
        [
            titleLabel,
            loginButton,
        ].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24.0)
            $0.centerX.equalTo(titleLabel)
        }
    }
    
    @objc func tapLoginButton() {
        GIDSignIn.sharedInstance().signIn()
    }
    
//    @objc func checkSign() {
//        showTabVCOnNav(self)
//    }
}
