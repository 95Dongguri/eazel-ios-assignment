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
    
    let labLabel = UILabel()
    
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
        getUserCurrentDB()
        getUserLabDB()
        setupLayout()
    }
}

private extension TimerViewController {
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
    
    func changeButton(_ button: UIButton, title: String, titleColor: UIColor) {
        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(titleColor, for: UIControl.State())
    }
    
    func resetTimer(_ stopwatch: StopWatch, label: UILabel) {
        stopwatch.timer.invalidate()
        stopwatch.count = 0.0
        label.text = "00:00:00"
    }
    
    func updateTimer(_ stopwatch: StopWatch, label: UILabel) {
        stopwatch.count = stopwatch.count + interval
        
        var minutes: String = "\((Int)(stopwatch.count / 60))"
        if (Int)(stopwatch.count / 60) < 10 {
            minutes = "0\((Int)(stopwatch.count / 60))"
        }
        
        var seconds: String = String(format: "%.2f", (stopwatch.count.truncatingRemainder(dividingBy: 60)))
        if stopwatch.count.truncatingRemainder(dividingBy: 60) < 10 {
            seconds = "0" + seconds
        }
        
        label.text = minutes + ":" + seconds
    }
    
    func resetMainTimer() {
        resetTimer(mainTimer, label: timerLabel)
        labList.removeAll()
        labsTableView.reloadData()
    }
    
    func resetLabTimer() {
        resetTimer(labTimer, label: labLabel)
    }
    
    func resetUserDB() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let ref: DatabaseReference!
        ref = Database.database().reference(withPath: "LabData")
        
        ref.child("\(uid)").removeValue()
    }
    
    func getUserCurrentDB() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let ref: DatabaseReference!
        ref = Database.database().reference(withPath: "LabData")
        
        ref.child("\(uid)").child("Current").observeSingleEvent(of: .value) { snapshot in
            guard let current = snapshot.value as? Double else { return }
            
            self.mainTimer.count = current
            
            DispatchQueue.main.async { [self] in
                self.updateTimer(mainTimer, label: timerLabel)
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
    
    func setUserDB(_ current: Double,_ lab: [String]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref: DatabaseReference!
        ref = Database.database().reference(withPath: "LabData")
        
        let userLabRef = ref.child("\(uid)").child("Lab")
        let userCurrentRef = ref.child("\(uid)").child("Current")
        
        userLabRef.setValue(lab)
        userCurrentRef.setValue(current)
    }
    
    @objc func tapLabResetButton() {
        if !isPlaying {
            resetMainTimer()
            resetLabTimer()
            resetUserDB()
            changeButton(labresetButton, title: "랩", titleColor: UIColor.lightGray)
            labresetButton.isEnabled = false
        } else {
            if let labText = labLabel.text {
                labList.insert(labText, at: 0)
            }
//            if let currentText = timerLabel.text {
//                setUserDB(currentText, labList)
//            }
            setUserDB(mainTimer.count, labList)
//            setUserDB(labs)
            labsTableView.reloadData()
            resetLabTimer()
            labTimer.timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updateLabTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(labTimer.timer, forMode: RunLoop.Mode.common)
        }
    }
    
    
    @objc func tapStartPauseButton() {
        labresetButton.isEnabled = true
        
        changeButton(labresetButton, title: "랩", titleColor: UIColor.white)
        
        if !isPlaying {
            mainTimer.timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updateMainTimer), userInfo: nil, repeats: true)
            labTimer.timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updateLabTimer), userInfo: nil, repeats: true)
            
            RunLoop.current.add(mainTimer.timer, forMode: RunLoop.Mode.common)
            RunLoop.current.add(labTimer.timer, forMode: RunLoop.Mode.common)
            
            isPlaying = true
            changeButton(startpauseButton, title: "중단", titleColor: UIColor.red)
        } else {
            mainTimer.timer.invalidate()
            labTimer.timer.invalidate()
            
            setUserDB(mainTimer.count, labList)
            
            isPlaying = false
            changeButton(startpauseButton, title: "시작", titleColor: UIColor.systemBlue)
            changeButton(labresetButton, title: "재설정", titleColor: UIColor.white)
        }
    }
    
    @objc func updateMainTimer() {
        updateTimer(mainTimer, label: timerLabel)
    }
    
    @objc func updateLabTimer() {
        updateTimer(labTimer, label: labLabel)
    }
}

extension TimerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimerTableViewCell.identifier, for: indexPath) as? TimerTableViewCell else { return UITableViewCell() }
        
        let lab = labList[indexPath.row]
        
        cell.setup(labList.count - indexPath.row, lab)
        
        return cell
    }
}
