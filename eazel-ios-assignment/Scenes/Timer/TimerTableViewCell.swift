//
//  TimerTableViewCell.swift
//  eazel-ios-assignment
//
//  Created by 김동혁 on 2022/07/27.
//

import SnapKit
import UIKit

class TimerTableViewCell: UITableViewCell {
    static let identifier = "TimerTableViewCell"
    
    let indexLabel = UILabel()
    let labtimeLabel = UILabel()
    
    /// 셀 구성요소 설정
    func setup(_ index: Int, _ lab: String) {
        [
            indexLabel,
            labtimeLabel
        ].forEach {
            addSubview($0)
        }
        
        indexLabel.font = .systemFont(ofSize: 18.0, weight: .bold)
        labtimeLabel.font = .systemFont(ofSize: 18.0, weight: .bold)
        
        indexLabel.text = "랩 \(index)"
        labtimeLabel.text = lab
        
        indexLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.centerY.equalToSuperview()
        }
        
        labtimeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.0)
            $0.centerY.equalTo(indexLabel)
        }
    }
}
