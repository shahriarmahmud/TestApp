//
//  APIEndPoints.swift
//  TestApp
//
//  Created by Shahriar Mahmud on 26/7/19.
//  Copyright © 2019 Shahriar Mahmud. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//MARK:- EmployeeData
enum EmployeeDataEndPoint: Endpoint {
    
    case GetEmployeeData
    
    var method: HTTPMethod {
        switch self {
        case .GetEmployeeData:
            return .get
        
        }
    }
    
    var path: String {
        switch self {
        case .GetEmployeeData:
            return KBasePath + OauthPath.getEmployeeList.rawValue
            
        }
    }
    
    var query: [String: Any]  {
        switch self {
        case .GetEmployeeData:
            return [String: Any]()
    
        }
    }
}
