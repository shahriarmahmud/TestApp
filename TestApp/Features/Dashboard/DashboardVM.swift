//
//  DashboardVM.swift
//  TestApp
//
//  Created by Shahriar Mahmud on 26/7/19.
//  Copyright © 2019 Shahriar Mahmud. All rights reserved.
//

import Foundation
import SVProgressHUD
import SwiftyJSON
import ObjectMapper
import CoreData

class DashboardVM{
    
    var dataCount = 0
    var employeeListData: [NSManagedObject] = []
//    var searchResultList: [NSManagedObject] = []
    
    
    func getEmployeeList (completion: @escaping (_ success: Bool) -> Void) {
        SVProgressHUD.show()
        APIClient.shared.makeAPICall(apiEndPoint: EmployeeDataEndPoint.GetEmployeeData) { (result) in
            switch result {
            case .success(let data ):
                guard let apiResponse = Mapper<EmployeeList>().mapArray(JSONObject: data) else {return}
                self.saveInDB(apiResponse)
                self.fetchAllEmployees { (success) in
                    if success {
                        self.dataCount = self.employeeListData.count
                    }else{
                        self.dataCount = 0
                    }
                }
                completion(true)
                SVProgressHUD.dismiss()
                
            case .failure(_,_,let error):
                print(error.localizedDescription)
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                completion(false)
            }
        }
    }
    
    // MARK:- Values to display in our table view controller
    var isEmptyTable: Bool {
        return employeeListData.isEmpty == true
    }
    
    var numberOfItemsToDisplay: Int{
        return employeeListData.count
    }
    
    func getEmployeeName(_ index:Int)->String{
        if employeeListData.count > 0 {
            guard let name = employeeListData[index].value(forKeyPath: Constants.employeeName) as? String else {return ""}
            return name
        }
        return ""
    }
    
    func getEmployeeAge(_ index:Int)->String{
        if employeeListData.count > 0 {
            guard let age = employeeListData[index].value(forKeyPath: Constants.employeeAge) as? String else {return ""}
            return age
        }
        return ""
    }
    
    func getEmployeeId(_ index:Int)->String{
        if employeeListData.count > 0 {
            guard let id = employeeListData[index].value(forKeyPath: Constants.employeeId) as? String else {return ""}
            return id
        }
        return ""
    }
    
    func getEmployeeImage(_ index:Int)->String{
        if employeeListData.count > 0 {
            guard let image = employeeListData[index].value(forKeyPath: Constants.employeeImage) as? String else {return ""}
            return image
        }
        return ""
        
    }
    
    func getEmployeeSalary(_ index:Int)->String{
        if employeeListData.count > 0 {
            guard let salary = employeeListData[index].value(forKeyPath: Constants.employeeSalary) as? String else {return ""}
            return salary
        }
        return ""
        
    }
    
    func searchResult(searchText:String){
        employeeListData = employeeListData.filter({ (employee) -> Bool in
            guard let name = employee.value(forKey: Constants.employeeName) as? String else {return false}
            return name.lowercased().contains(searchText.lowercased())
        })
    }
    
    func filterDataByRating(){
        let filtredArr = employeeListData.sorted(by: {
            guard let first = $0.value(forKey: Constants.employeeRating) as? String else {return false}
            guard let scnd = $1.value(forKey: Constants.employeeRating) as? String else {return false}
            guard let firstDouble = Double(first) else {return false}
            guard let scndDouble = Double(scnd) else {return false}
            
            return firstDouble > scndDouble
        })
        employeeListData = filtredArr
    }
    
    func fetchAllEmployees(completion: @escaping (_ success: Bool) -> Void){
        CoreDataManager.sharedManager.fetchAllEmployees(completion: { [weak self] (employees) in
            self?.employeeListData.removeAll()
            let filtredArr = employees.sorted(by: {
                guard let firstName = $0.value(forKey: Constants.employeeName) as? String else {return false}
                guard let scndName = $1.value(forKey: Constants.employeeName) as? String else {return false}
                
                return firstName.lowercased() < scndName.lowercased()
            })

            self?.employeeListData = filtredArr
            if employees.count > 0 {
                completion(true)
            }else{
                completion(false)
            }
        })
    }
    
    func saveInDB(_ employeeListArray:[EmployeeList]){
        for arrList in employeeListArray{
            guard let id = arrList.id else{return}
            if !CoreDataManager.sharedManager.isExist(id: id) {
                CoreDataManager.sharedManager.insertEmployee(id: id, name: arrList.employeeName ?? "n/a", salary: arrList.employeeSalary ?? "n/a", age: arrList.employeeAge ?? "n/a", rating: "0", image: arrList.employeeImage ?? "")
            }
            
        }
    }
    
    func saveSingleDataInDB(id:String, name:String, salary:String, age:String){
        CoreDataManager.sharedManager.insertEmployee(id: id, name: name, salary: salary, age: age, rating: "0", image: "")
        
        self.fetchAllEmployees { (success) in
            if success {
                self.dataCount = self.employeeListData.count
            }else{
                self.dataCount = 0
            }
        }
    }
}
