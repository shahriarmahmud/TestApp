//
//  TestAppTests.swift
//  TestAppTests
//
//  Created by Shahriar Mahmud on 26/7/19.
//  Copyright © 2019 Shahriar Mahmud. All rights reserved.
//

import XCTest
@testable import TestApp

class TestAppTests: XCTestCase {


    // Mark :- Dashboard Test
    func testInternetAvailable(){
        let isInternetAvalable  = Connectivity.isConnectedToInternet
        XCTAssertTrue(isInternetAvalable)
    }
    
    func fetchAllEmployeeData(){
        let viewModel = DashboardVM()
        viewModel.fetchAllEmployees { (success) in
            XCTAssertTrue(success)
        }
    }
    
    func getServerData(){
        let viewModel = DashboardVM()
        viewModel.getEmployeeList { (success) in
            XCTAssertTrue(success)
        }
    }
    
    func getEmployeeId(){
        let viewModel = DashboardVM()
        viewModel.getEmployeeList { (success) in
            if success {
                let list = viewModel.employeeListData
                
                let name = viewModel.getEmployeeId(0, false, list)
                XCTAssertNil(name)
            }
        }
    }
}
