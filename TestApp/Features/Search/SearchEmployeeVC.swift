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
    
    let refreshControl = UIRefreshControl()
    private let pullInitialStr = "Pull To Refresh"
    private let pullFetchStr = "Fetching Data"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        addRefreshControllToTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshControl.setValue(70, forKey: "_snappingHeight")
    }
    
    private func addRefreshControllToTableView() {
        refreshControl.attributedTitle = NSAttributedString(string: pullInitialStr)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh(sender:UIRefreshControl) {
        viewModel.fetchAllEmployees { (success) in
            if !success {
                self.viewModel.getEmployeeList { [weak self] (success) in
                    if success {
                        self?.apiCallDone = true
                        DispatchQueue.main.async {
                            sender.endRefreshing()
                            self?.tableView.reloadData()
                        }
                    }
                }
            }else{
                DispatchQueue.main.async {
                    sender.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        }
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
        viewModel.filterDataByRating()
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
            return viewModel.employeeListData.count
        }else{
             return viewModel.numberOfItemsToDisplay
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DashboardCell.identifire, for: indexPath) as! DashboardCell

        cell.setup(with: viewModel, index: indexPath.row)
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
        viewModel.searchResult(searchText: searchText)
        
        if(viewModel.employeeListData.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
}
