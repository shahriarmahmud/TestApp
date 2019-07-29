//
//  EmployeeResponse.swift
//  TestApp
//
//  Created by Shahriar Mahmud on 26/7/19.
//  Copyright © 2019 Shahriar Mahmud. All rights reserved.
//

import Foundation

struct EmployeeResponse: Decodable {
    
    var employeeList: [EmployeeList]?
}

struct EmployeeList: Decodable{
    var id:String?
    var employeeName:String?
    var employeeSalary:String?
    var employeeAge:String?
    var employeeImage:String?
    var employeeRating:String?
}

extension EmployeeResponse {
    
    static var all: Resource<EmployeeResponse> = {
        let url = URL(string: EmployeeDataEndPoint.GetEmployeeData.path)!
        return Resource(url: url)
    }()
    
}

