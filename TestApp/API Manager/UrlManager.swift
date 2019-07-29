//
//  UrlManager.swift
//  TestApp
//
//  Created by Shahriar Mahmud on 26/7/19.
//  Copyright © 2019 Shahriar Mahmud. All rights reserved.
//
import Foundation

#if DEVELOPMENT

let KBasePath = "http://dummy.restapiexample.com" // Staging Server
#else

let KBasePath = "http://dummy.restapiexample.com" // Production Server

#endif

enum OauthPath: String {
    
    case getEmployeeList     = "/api/v1/employees"
}
