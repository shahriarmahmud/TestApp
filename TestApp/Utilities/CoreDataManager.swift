//
//  CoreDataManager.swift
//  TestApp
//
//  Created by Shahriar Mahmud on 26/7/19.
//  Copyright © 2019 Shahriar Mahmud. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
  
  static let sharedManager = CoreDataManager()
  private init() {}

  lazy var persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: Constants.dbName)
    
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  //3
  func saveContext () {
    let context = CoreDataManager.sharedManager.persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
       
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
    func insertEmployee(id: String, name: String, salary: String, age: String, rating: String, image: String) {
   
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    
    let entity = NSEntityDescription.entity(forEntityName: Constants.dbTableName,
                                            in: managedContext)!

    let employee = NSManagedObject(entity: entity,
                                 insertInto: managedContext)
    
        employee.setValue(id, forKeyPath: Constants.employeeId)
        employee.setValue(name, forKeyPath: Constants.employeeName)
        employee.setValue(salary, forKeyPath: Constants.employeeSalary)
        employee.setValue(age, forKeyPath: Constants.employeeAge)
        employee.setValue(rating, forKeyPath: Constants.employeeRating)
        employee.setValue(image, forKeyPath: Constants.employeeImage)
        

    do {
      try managedContext.save()
//      return employee as? Employee
        
        print("\(employee.value(forKey: Constants.employeeName) ?? "n/a")")
        print("\(employee.value(forKey: Constants.employeeSalary) ?? "0")")
        print("\(employee.value(forKey: Constants.employeeAge) ?? "0")")
        print("\(employee.value(forKey: Constants.employeeRating) ?? "0.0")")
        print("\(employee.value(forKey: Constants.employeeImage) ?? "")")
        print("\(employee.value(forKey: Constants.employeeId) ?? "0")")
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
//      return nil
    }
  }
  
    func update(name: String, salary: String, age: String, rating: String, id: String, employee : EmployeeData) {
    
    let context = CoreDataManager.sharedManager.persistentContainer.viewContext
    
    do {
        employee.setValue(name, forKeyPath: Constants.employeeName)
        employee.setValue(id, forKeyPath: Constants.employeeId)
        employee.setValue(salary, forKeyPath: Constants.employeeSalary)
        employee.setValue(age, forKeyPath: Constants.employeeAge)
        employee.setValue(rating, forKeyPath: Constants.employeeRating)
      
        print("\(employee.value(forKey: Constants.employeeName) ?? "n/a")")
        print("\(employee.value(forKey: Constants.employeeSalary) ?? "0")")
        print("\(employee.value(forKey: Constants.employeeAge) ?? "0")")
        print("\(employee.value(forKey: Constants.employeeRating) ?? "0.0")")
        print("\(employee.value(forKey: Constants.employeeId) ?? "0")")

      do {
        try context.save()
        print("saved!")
      } catch let error as NSError  {
        print("Could not save \(error), \(error.userInfo)")
      }
      
    }
  }
  
  /*delete*/
  func delete(employee : EmployeeData){
    
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    
    do {
      
      managedContext.delete(employee)
      
    } catch {
      print(error)
    }
    
    do {
      try managedContext.save()
    }catch{
        
    }
  }
  
  func fetchAllEmployees(completion: @escaping (_ employee: [Employee]) -> Void) {
    
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.dbTableName)
   
    do {
      let employee = try managedContext.fetch(fetchRequest)
        completion(employee as! [Employee])
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
      return completion([Employee]())
    }
  }
    
    func isExist(id: String) -> Bool {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.dbTableName)
        
        fetchRequest.predicate = NSPredicate(format: "eId = %d",id)
        
        let res = try! managedContext.fetch(fetchRequest)
        return res.count > 0 ? true : false
    }
  
  func delete(id: String) -> [Employee]? {

    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext

    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.dbTableName)
    
    fetchRequest.predicate = NSPredicate(format: "eName == %@" ,id)
    do {

      let item = try managedContext.fetch(fetchRequest)
      var arrRemovedPeople = [Employee]()
      for i in item {
        managedContext.delete(i)

        try managedContext.save()

        arrRemovedPeople.append(i as! Employee)
      }
      return arrRemovedPeople
      
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
  return nil
    }
    
  }
}

