//
//  StopWatch.swift
//  eazel-ios-assignment
//
//  Created by κΉλν on 2022/07/27.
//

import Foundation

class StopWatch: NSObject {
    var count: Double
    var timer: Timer
    
    override init() {
        count = 0.0
        timer = Timer()
    }
}
