//
//  TimerViewController.swift
//  eazel-ios-assignment
//
//  Created by 김동혁 on 2022/07/27.
//

import FirebaseDatabase
import FirebaseAuth
import SnapKit
import UIKit

class TimerViewController: UIViewController {
    let viewModel = TimerViewModel()
    
    private let mainTimer: StopWatch = StopWatch()
    private let labTimer: StopWatch = StopWatch()
    
    private var isPlaying: Bool = false
    private var labList: [String] = []
    
    private let interval = 0.01
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment  = .center
        label.font = .systemFont(ofSize: 80.0, weight: .medium)
        label.text = "00:00.00"
        
        return label
    }()
    
    private lazy var labLabel = UILabel()
    
    private lazy var labresetButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 100.0, height: 100.0)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.backgroundColor = .darkGray
        button.layer.borderWidth = 0.5
        button.setTitle("랩", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.clipsToBounds = false
        
        button.addTarget(self, action: #selector(tapLabResetButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var startpauseButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 100.0, height: 100.0)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.backgroundColor = .systemMint
        button.layer.borderWidth = 0.5
        button.setTitle("시작", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.clipsToBounds = false
        
        button.addTarget(self, action: #selector(tapStartPauseButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var labsTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 50.0
        tableView.register(TimerTableViewCell.self, forCellReuseIdentifier: TimerTableViewCell.identifier)
        
        tableView.dataSource = self
        
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppearanceCheck(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserCurrentDB()
        getUserLabDB()
        setupLayout()
    }
}

private extension TimerViewController {
    /// 레이아웃 설정
    func setupLayout() {
        [
            timerLabel,
            labresetButton,
            startpauseButton,
            labsTableView
        ].forEach {
            view.addSubview($0)
        }
        
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(view.bounds.width)
            $0.height.equalTo(300.0)
        }
        
        labresetButton.snp.makeConstraints {
            $0.top.equalTo(timerLabel.snp.bottom).offset(16.0)
            $0.leading.equalToSuperview().inset(8.0)
            $0.width.height.equalTo(100.0)
        }
        
        startpauseButton.snp.makeConstraints {
            $0.top.equalTo(labresetButton)
            $0.trailing.equalToSuperview().inset(8.0)
            $0.width.height.equalTo(100.0)
        }
        
        labsTableView.snp.makeConstraints {
            $0.top.equalTo(labresetButton.snp.bottom).offset(16.0)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func resetMainTimer() {
        viewModel.resetTimer(mainTimer, label: timerLabel)
        labList.removeAll()
        labsTableView.reloadData()
    }
    
    func resetLabTimer() {
        viewModel.resetTimer(labTimer, label: labLabel)
    }
    
    func getUserCurrentDB() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let ref: DatabaseReference!
        ref = Database.database().reference(withPath: "LabData")
        
        ref.child("\(uid)").child("Current").observeSingleEvent(of: .value) { snapshot in
            guard let current = snapshot.value as? Double else { return }
            
            self.mainTimer.count = current
            
            DispatchQueue.main.async { [self] in
                self.viewModel.updateTimer(mainTimer, label: timerLabel)
            }
        }
    }
    
    func getUserLabDB() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref: DatabaseReference!
        ref = Database.database().reference(withPath: "LabData")
        
        ref.child("\(uid)").child("Lab").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String] else { return }
            
            let labs = Array(value)
            self.labList = labs
            
            DispatchQueue.main.async {
                self.labsTableView.reloadData()
            }
        }
    }
    
    @objc func tapLabResetButton() {
        if !isPlaying {
            resetMainTimer()
            resetLabTimer()
            
            viewModel.resetUserDB()
            viewModel.changeButton(labresetButton, title: "랩", titleColor: UIColor.lightGray)
            
            labresetButton.isEnabled = false
        } else {
            if let labText = labLabel.text {
                labList.insert(labText, at: 0)
            }

            viewModel.setUserDB(mainTimer.count, labList)
            labsTableView.reloadData()
            
            resetLabTimer()
            
            labTimer.timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updateLabTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(labTimer.timer, forMode: RunLoop.Mode.common)
        }
    }
    
    
    @objc func tapStartPauseButton() {
        labresetButton.isEnabled = true
        
        viewModel.changeButton(labresetButton, title: "랩", titleColor: UIColor.white)

        if !isPlaying {
            mainTimer.timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updateMainTimer), userInfo: nil, repeats: true)
            labTimer.timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updateLabTimer), userInfo: nil, repeats: true)

            RunLoop.current.add(mainTimer.timer, forMode: RunLoop.Mode.common)
            RunLoop.current.add(labTimer.timer, forMode: RunLoop.Mode.common)
            
            isPlaying = true
            
            viewModel.changeButton(startpauseButton, title: "중단", titleColor: UIColor.red)
        } else {
            mainTimer.timer.invalidate()
            labTimer.timer.invalidate()
            
            viewModel.setUserDB(mainTimer.count, labList)
            
            isPlaying = false

            viewModel.changeButton(startpauseButton, title: "시작", titleColor: UIColor.systemBlue)
            viewModel.changeButton(labresetButton, title: "재설정", titleColor: UIColor.white)
        }
    }
    
    @objc func updateMainTimer() {
        viewModel.updateTimer(mainTimer, label: timerLabel)
    }
    
    @objc func updateLabTimer() {
        viewModel.updateTimer(labTimer, label: labLabel)
    }
}

// MARK: - UITableView DataSource
extension TimerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimerTableViewCell.identifier, for: indexPath) as? TimerTableViewCell else { return UITableViewCell() }
        
        let lab = labList[indexPath.row]
        let index = labList.count - indexPath.row
        
        cell.setup(index, lab)
        
        return cell
    }
}
