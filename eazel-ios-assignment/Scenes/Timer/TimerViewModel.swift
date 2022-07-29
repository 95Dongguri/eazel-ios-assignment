//
//  TimerViewModel.swift
//  eazel-ios-assignment
//
//  Created by 김동혁 on 2022/07/28.
//

import FirebaseAuth
import FirebaseDatabase

struct TimerViewModel {
    /// 인터벌 설정
    let interval = 0.01

// MARK: 타이머 함수
    /// 타이머 업데이트
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
    
    /// 타이머 중지
    func invalidateTimer(_ stopwatch: StopWatch) {
        stopwatch.timer.invalidate()
    }
    
    /// 타이머 초기화
    func resetTimer(_ stopwatch: StopWatch, label: UILabel) {
        stopwatch.timer.invalidate()
        stopwatch.count = 0.0
        label.text = "00:00.00"
    }
    
// MARK: UI 함수
    /// 버튼 스타일 변경
    func changeButton(_ button: UIButton, title: String, titleColor: UIColor) {
        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(titleColor, for: UIControl.State())
    }
    
// MARK: 데이터베이스 함수
    /// 유저 데이터베이스 설정
    func setUserDB(_ current: Double, _ lab: [String]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref: DatabaseReference!
        ref = Database.database().reference(withPath: "LabData")
        
        let userLabRef = ref.child("\(uid)").child("Lab")
        let userCurrentRef = ref.child("\(uid)").child("Current")
        
        userLabRef.setValue(lab)
        userCurrentRef.setValue(current)
    }
    
    /// 유저 데이터베이스 초기화
    func resetUserDB() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let ref: DatabaseReference!
        ref = Database.database().reference(withPath: "LabData")
        
        ref.child("\(uid)").removeValue()
    }
}
