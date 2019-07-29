//
//  ViewController.swift
//  TestApp
//
//  Created by Shahriar Mahmud on 26/7/19.
//  Copyright © 2019 Shahriar Mahmud. All rights reserved.
//

import UIKit
import RxSwift

class DashboardVC: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView!
    private var viewModel = DashboardVM()
    private var apiCallDone = false
    
    let disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()
        if Connectivity.isConnectedToInternet {
            print("Connected")
            getData()
        } else {
            print("No Internet")
            showNoInternetDialog()
        }
    }
    
    private func showNoInternetDialog(){
        let alertControl = UIAlertController(title: "No Internet", message: "Please check you internet conectivity", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertControl.addAction(okAction)
        alertControl.show()
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
}

// Mark :- tableview Datasource & delegate
extension DashboardVC: UITableViewDelegate,UITableViewDataSource {
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
        let sb = UIStoryboard(storyboard: .main)
        let vc = sb.instantiateViewController(withIdentifier: EmployeeDetailsVC.self)
        vc.employee = employee
        present(vc, animated: true, completion: nil)
    }
}


