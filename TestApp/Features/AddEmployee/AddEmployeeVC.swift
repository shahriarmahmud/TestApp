//
//  AddEmployeeVC.swift
//  TestApp
//
//  Created by Shahriar Mahmud on 26/7/19.
//  Copyright © 2019 Shahriar Mahmud. All rights reserved.
//

import UIKit
import CoreData

class AddEmployeeVC: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView!
    private var viewModel = DashboardVM()
    private var apiCallDone = false
    private var counter = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counter = Helper.getLastSavedId()
        getData()
    }
    
    private func getData(){
        viewModel.fetchAllEmployees { (success) in
            if !success {
                self.viewModel.getEmployeeList { [weak self] (success) in
                    if success {
                        self?.apiCallDone = true
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        showAddAlertDialog()
    }
    
    private func showAddAlertDialog(){
        let alert = UIAlertController(title: "Add New",message: "New Employee", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textFieldName) in
            textFieldName.placeholder = "name"
            textFieldName.keyboardType = .asciiCapable
        })
        
        alert.addTextField(configurationHandler: { (textFieldSalary) in
            textFieldSalary.placeholder = "salary"
            textFieldSalary.keyboardType = .asciiCapableNumberPad
        })
        
        alert.addTextField(configurationHandler: { (textFieldAge) in
            textFieldAge.placeholder = "age"
            textFieldAge.keyboardType = .asciiCapableNumberPad
        })
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            self.saveAction(alert: alert)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    private func showUpdateDialog(employee: NSManagedObject){
        let alert = UIAlertController(title: "Update Employee",
                                      message: "Employee Details",
                                      preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { (textFieldName) in
            textFieldName.placeholder = "name"
            textFieldName.keyboardType = .asciiCapable
            textFieldName.text = employee.value(forKey: "eName") as? String
        })
        
        alert.addTextField(configurationHandler: { (textFieldSalary) in
            textFieldSalary.placeholder = "Salary"
            textFieldSalary.keyboardType = .asciiCapableNumberPad
            textFieldSalary.text = employee.value(forKey: Constants.employeeSalary) as? String
        })
        
        alert.addTextField(configurationHandler: { (textFieldAge) in
            textFieldAge.placeholder = "Age"
            textFieldAge.keyboardType = .asciiCapableNumberPad
            textFieldAge.text = employee.value(forKey: Constants.employeeAge) as? String
        })

        let updateAction = UIAlertAction(title: "Update", style: .default) { [unowned self] action in
            self.updateAlertAction(alert: alert, employee: employee)
        }

        let deleteAction = UIAlertAction(title: "Delete", style: .default) { [unowned self] action in
            self.deleteAlertAction(employee: employee)
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    
    // Mark :- Delete Action
    private func deleteAlertAction(employee: NSManagedObject){
        CoreDataManager.sharedManager.delete(employee: employee as! EmployeeData)
        var tempData = self.viewModel.employeeListData
        tempData.remove(at: (tempData.firstIndex(of: employee))!)
        self.viewModel.employeeListData = tempData
        self.tableView.reloadData()
    }
    
    // Mark :- Save Action
    private func saveAction(alert:UIAlertController){
        guard let textField = alert.textFields?.first,
            let nameToSave = textField.text else {return}
        
        guard let textFieldSalary = alert.textFields?[1],
            let salaryToSave = textFieldSalary.text else {return}
        
        guard let textFieldAge = alert.textFields?[2],
            let ageToSave = textFieldAge.text else {return}
        
        let id = "n" + String(self.counter)
        Helper.saveLastSavedId(with: self.counter)
        self.counter = self.counter + 1
        
        self.viewModel.saveSingleDataInDB(id: id, name: nameToSave, salary: salaryToSave, age: ageToSave)
        
        self.tableView.reloadData()
    }
    
    // Mark :- Update Action
    private func updateAlertAction(alert:UIAlertController, employee: NSManagedObject){
        guard let textField = alert.textFields?.first,
            let nameToSave = textField.text else {
                return
        }
        
        guard let textFieldSalary = alert.textFields?[1],
            let salaryToSave = textFieldSalary.text else {
                return
        }
        
        guard let textFieldAge = alert.textFields?[2],
            let ageToSave = textFieldAge.text else {
                return
        }
        
        let rating = employee.value(forKey: Constants.employeeRating) as? String ?? "0"
        let id = employee.value(forKey: Constants.employeeId) as? String ?? "0"
        
        CoreDataManager.sharedManager.update(name: nameToSave, salary: salaryToSave, age: ageToSave, rating: rating, id: id, employee: (employee as? EmployeeData)!)
        
        self.tableView.reloadData()
    }
}


// Mark :- tableview Datasource & delegate
extension AddEmployeeVC: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.numberOfItemsToDisplay == 0 {
            Helper.emptyMessageInTableView(tableView, "No Data Available")
        }
        else {
            tableView.backgroundView = nil
        }
        return viewModel.numberOfItemsToDisplay
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DashboardCell.identifire, for: indexPath) as! DashboardCell
        cell.setup(with: viewModel, searchemployeeListData: viewModel.employeeListData, index: indexPath.section, isSearch: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let employee = viewModel.employeeListData[indexPath.section]
        showUpdateDialog(employee: employee)
    }
}
