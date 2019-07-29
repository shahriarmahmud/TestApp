//
//  SAError.swift
//  Single App
//
//  Created by Shahriar on 8/30/18.
//  Copyright © 2018 Sadrulnascenia. All rights reserved.
//

import Foundation

enum SAError: Int {
    case unauthorized   = 401
    case notFound       = 404
    case timeOut        = 408
    case preconditioned = 412
    case invalidParam   = 422
    case soaDown        = 424
    case serverProblem  = 500
}
