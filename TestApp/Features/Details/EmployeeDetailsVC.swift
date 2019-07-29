//
//  EmployeeDetailsVC.swift
//  TestApp
//
//  Created by Shahriar Mahmud on 26/7/19.
//  Copyright © 2019 Shahriar Mahmud. All rights reserved.
//

import UIKit
import CoreData
import Cosmos

class EmployeeDetailsVC: UIViewController {
    
    @IBOutlet weak private var employeeImage: UIImageView!
    @IBOutlet weak private var employeeIdLbl: UILabel!
    @IBOutlet weak private var employeeNameLbl: UILabel!
    @IBOutlet weak private var employeeSalaryLbl: UILabel!
    @IBOutlet weak private var employeeAgeLbl: UILabel!
    @IBOutlet weak private var ratingView: CosmosView!
    private var userRating = 0.0
    
    var employee: NSManagedObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        showData()
    }
    
    private func showData(){
        guard let emplyee = employee else {return}
        employeeIdLbl.text = "Id: \(emplyee.value(forKey: Constants.employeeId) as? String ?? "")"
        employeeNameLbl.text = "Name: \(emplyee.value(forKey: Constants.employeeName) as? String ?? "")"
        employeeAgeLbl.text = "Age: \(emplyee.value(forKey: Constants.employeeAge) as? String ?? "")"
        employeeSalaryLbl.text = "Salary: \(emplyee.value(forKey: Constants.employeeSalary) as? String ?? "")"
        
        let image = emplyee.value(forKey: Constants.employeeImage) as? String ?? "placeholder"
        if image != "" {
            employeeImage.image = UIImage(named: emplyee.value(forKey: Constants.employeeImage) as? String ?? "placeholder")
        }else{
            employeeImage.image = UIImage(named: "placeholder")
        }
        
        // rating view
        let rating = emplyee.value(forKey: Constants.employeeRating) as? String ?? "0.0"
        ratingView.rating = Double(rating) ?? 0.0
        self.userRating = Double(rating) ?? 0.0
        ratingView.didFinishTouchingCosmos = { rating in
            self.userRating = rating
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        closeAction()
    }
    
    private func closeAction(){
        guard let emplyee = employee else {return}
        let id = emplyee.value(forKey: Constants.employeeId) as? String ?? ""
        let name = emplyee.value(forKey: Constants.employeeName) as? String ?? ""
        let salary = emplyee.value(forKey: Constants.employeeSalary) as? String ?? ""
        let age = emplyee.value(forKey: Constants.employeeAge) as? String ?? ""
        let rating = userRating
        
        CoreDataManager.sharedManager.update(name: name, salary: salary, age: age, rating: String(rating),id: id, employee: emplyee as! EmployeeData)
        self.dismiss(animated: true, completion: nil)
    }
    
}
