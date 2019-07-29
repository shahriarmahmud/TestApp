//
//  SearchVC.swift
//  TestApp
//
//  Created by Shahriar Mahmud on 26/7/19.
//  Copyright © 2019 Shahriar Mahmud. All rights reserved.
//

import UIKit
import CoreData

class SearchEmployeeVC: UIViewController {

    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var tableView: UITableView!
    
    private var searchActive : Bool = false
    private var viewModel = DashboardVM()
    private var apiCallDone = false
    private var searchResultList: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    @IBAction func filterAction(_ sender: Any) {
        filterDataByRating()
    }
    
    private func filterDataByRating(){
        let filtredArr = viewModel.employeeListData.sorted(by: {
            guard let first = $0.value(forKey: Constants.employeeRating) as? String else {return false}
            guard let scnd = $1.value(forKey: Constants.employeeRating) as? String else {return false}
            guard let firstDouble = Double(first) else {return false}
            guard let scndDouble = Double(scnd) else {return false}
            
            return firstDouble > scndDouble
        })
        viewModel.employeeListData = filtredArr
        tableView.reloadData()
    }
    
}


// Mark : tableview delegate & data source
extension SearchEmployeeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfItemsToDisplay == 0 {
            Helper.emptyMessageInTableView(tableView, "No Data Available")
        }
        else {
            tableView.backgroundView = nil
        }
        
        if(searchActive) {
            return searchResultList.count
        }else{
             return viewModel.numberOfItemsToDisplay
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DashboardCell.identifire, for: indexPath) as! DashboardCell

        if(searchActive){
            cell.setup(with: viewModel, searchemployeeListData: searchResultList, index: indexPath.row, isSearch: true)
        }else {
            cell.setup(with: viewModel, searchemployeeListData: searchResultList, index: indexPath.row, isSearch: false)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

// Mark : search delegate
extension SearchEmployeeVC: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        searchResultList = viewModel.employeeListData.filter({ (employee) -> Bool in
            guard let name = employee.value(forKey: Constants.employeeName) as? String else {return false}
            return name.lowercased().contains(searchText.lowercased())
        })
        
        if(searchResultList.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
}
