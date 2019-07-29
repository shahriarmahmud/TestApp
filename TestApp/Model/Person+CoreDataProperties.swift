//
//  Employee+CoreDataProperties.swift
//  TestApp
//
//  Created by Shahriar Mahmud on 26/7/19.
//  Copyright © 2019 Shahriar Mahmud. All rights reserved.
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var salary: String?
    @NSManaged public var age: String?
    @NSManaged public var rating: String?

}
