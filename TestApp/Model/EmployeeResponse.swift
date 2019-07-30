//
//  EmployeeResponse.swift
//  TestApp
//
//  Created by Shahriar Mahmud on 26/7/19.
//  Copyright © 2019 Shahriar Mahmud. All rights reserved.
//

import Foundation
import ObjectMapper

struct EmployeeResponse: Mappable {
    
    var employeeList: [EmployeeList]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        employeeList <- map[""]
    }
}

struct EmployeeList: Mappable{
    var id:String?
    var employeeName:String?
    var employeeSalary:String?
    var employeeAge:String?
    var employeeImage:String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        employeeName <- map["employee_name"]
        employeeSalary <- map["employee_salary"]
        employeeAge <- map["employee_age"]
        id <- map["id"]
        employeeImage <- map["profile_image"]
    }
}
