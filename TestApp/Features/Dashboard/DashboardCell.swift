//
//  DashboardCell.swift
//  TestApp
//
//  Created by Shahriar Mahmud on 26/7/19.
//  Copyright © 2019 Shahriar Mahmud. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class DashboardCell: UITableViewCell {
    
    public static let identifire = "DashboardCell"
    
    @IBOutlet weak private var profileImage: UIImageView!
    @IBOutlet weak private var employeeNameLbl: UILabel!
    @IBOutlet weak private var employeeSalaryLbl: UILabel!
    @IBOutlet weak private var employeeAgeLbl: UILabel!
    @IBOutlet weak private var employeeId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setStyle(){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        employeeNameLbl.textColor = UIColor.orange
    }
    
    func setup(with viewModel: DashboardVM, index: Int) {
        employeeNameLbl.text = "Name : \(viewModel.getEmployeeName(index))"
        employeeSalaryLbl.text = "Salary : \(viewModel.getEmployeeSalary(index))"
        employeeAgeLbl.text = "Age : \(viewModel.getEmployeeAge(index))"
        profileImage.sd_setImage(with: URL(string: viewModel.getEmployeeImage(index)), placeholderImage: UIImage(named: "placeholder"))
        employeeId.text = "Id : \(viewModel.getEmployeeId(index))"
    }

}
