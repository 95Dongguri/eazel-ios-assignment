//
//  SettingViewModelTests.swift
//  eazel-ios-assignmentTests
//
//  Created by 김동혁 on 2022/07/31.
//

import FirebaseAuth
import XCTest
@testable import eazel_ios_assignment

class SettingViewModelTests: XCTestCase {
    var sut: SettingViewModel!
    
    override func setUp() {
        super.setUp()
        
        sut = SettingViewModel()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func test_logout_Success() {
        XCTAssertNoThrow(sut.logout(UIViewController()))
    }
    
    func test_updateUser() {
        sut.updateUser(UILabel())
        
        XCTAssertNil(UILabel().text)
    }
}
