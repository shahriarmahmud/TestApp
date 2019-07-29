//
//  Endpoint.swift
//  TestApp
//
//  Created by Shahriar Mahmud on 26/7/19.
//  Copyright © 2019 Shahriar Mahmud. All rights reserved.
//

import Foundation
import Alamofire

/**
 *  Protocol for all endpoints to conform to.
 */
protocol Endpoint {
    var method: HTTPMethod { get }
    var path: String { get }
    var query: [String: Any] { get }
    var encoding: ParameterEncoding { get set}
}

extension Endpoint {
    var encoding: ParameterEncoding { get{return URLEncoding.default} set {} }
}

