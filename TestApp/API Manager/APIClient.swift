//
//  APIClient.swift
//  TestApp
//
//  Created by Shahriar Mahmud on 26/7/19.
//  Copyright © 2019 Shahriar Mahmud. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

public enum Result<T> {
    case success(T)
    case failure(ErrorResponse)
}

typealias CompletionHandler<T> = (Result<T>) -> ()
public typealias ErrorResponse = (Int, Data?, Error)
typealias SocialCompletion = (HTTPURLResponse) -> ()


class APIClient {
    
    private static var privateShared : APIClient?
    
    class var shared: APIClient {
        guard let uwShared = privateShared else {
            privateShared = APIClient()
            return privateShared!
        }
        return uwShared
    }
    
    class func destroy() {
        privateShared = nil
    }
    
    deinit {
        print("deinit singleton")
    }
    
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 62 //second as in backend it's 60
        configuration.timeoutIntervalForResource = 62 //second as in backend it's 60
        return SessionManager(configuration: configuration)
    }()
    
    private init() {
        sessionManager.retrier = OAuth2Handler()
    }
    
    private let preLogHeaders = ["platform" : "ios", "appname" : "testApp"]
    
    
    private var saHeaders: [String:String]? {
        return ["token" :  "token"].merging(preLogHeaders) {$1}
    }
    
    func makeAPICall(apiEndPoint: Endpoint, completion: @escaping CompletionHandler<Any>) {
        Alamofire.request(apiEndPoint.path, method: apiEndPoint.method, parameters: apiEndPoint.query, encoding: apiEndPoint.encoding, headers: saHeaders)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    completion(Result.success(value))
                case .failure(let error):
                    print(error.localizedDescription)
                    guard let statusCode = response.response?.statusCode else {
                        let unKnownError = ErrorResponse(-999, response.data, error)
                        completion(Result.failure(unKnownError))
                        return
                    }
                    let mError = ErrorResponse(statusCode, response.data, error)
                    completion(Result.failure(mError))
                }
        }
    }
   
}





