//
//  OAuth2Handler.swift
//  TestApp
//
//  Created by Shahriar Mahmud on 26/7/19.
//  Copyright © 2019 Shahriar Mahmud. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

class OAuth2Handler: RequestRetrier {
    
    var isFirstAuthenticationFailed = true
    var presentedAlert: UIAlertController?
    
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if let response = request.task?.response as? HTTPURLResponse {
            guard let errorCode = SAError(rawValue: response.statusCode) else {
                isFirstAuthenticationFailed = true
                completion(false, 0.0) // don't retry
                return
            }
            switch errorCode {
            case .unauthorized:
                print("******** Get Access Token ********")
                completion(false, 0.0 ) // newly added not present in robi
            case .timeOut:
                print("******** REQUEST TIME OUT ********")
                print("Retry Count = \(request.retryCount)")
                print("requested URL = \(String(describing: response.url))")
                if request.retryCount == 3 { completion(false, 0.0 ); return}
                completion(true, 1.0) // retry after 1 second
            case .invalidParam:
                print("************ ============ ************")
                print("******* WRONG PARAMETER SEND TO API *******")
                completion(false, 0.0 )
            case .notFound:
                print("************ ============ ************")
                print("******* NOT FOUND IN SERVER *******")
                completion(false, 0.0 )
            case .soaDown:
                print("************ ============ ************")
                print("******* SOA DOWN Robi PROBLEM *******")
                completion(false, 0.0 )
            case .serverProblem:
                print("************ ============ ************")
                print("******* BACKEND INTERNAL SERVER PROBLEM *******")
                completion(false, 0.0 )
            case .preconditioned:
                print("************ ============ ************")
                print("******* PRE CONDITION FAILED *******")
                completion(false, 0.0 )
            }
            
        } else {
            isFirstAuthenticationFailed = true
            completion(false, 0.0) // don't retry
        }
    }
    
}








