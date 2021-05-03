//
//  ViewController.swift
//  ClientList
//
//  Created by Alessandro Pace on 1/5/21.
//

import UIKit


class ClientListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //MARK:: -- OUTLETS --
    
    @IBOutlet weak var clientsTableView: UITableView!
    
    //MARK:: -- VARS --
    
    let viewModel = ClientListViewModel()
    
    //MARK:: -- OVERRIDE METHODS --
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScreen()
    }
    
    //MARK:: -- IBACTIONS --
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        viewModel.showOptionSheet(firstOption: "Filter by visited", secondOption: "Filter by Not visited", handlerFirstAction: { (_) in
            self.viewModel.filterByVisited = true
            self.viewModel.filterClients = true
        }, handlerSecondAction: { (_) in
            self.viewModel.filterByVisited = false
            self.viewModel.filterClients = true
        }, handlerActionCancel: { (_) in
            self.viewModel.filterClients = false
        }, vc: self)
    }
    
    @IBAction func orderButtonTapped(_ sender: Any) {
        viewModel.showOptionSheet(firstOption: "Order by client name", secondOption: "Order by client code", handlerFirstAction: { (_) in
            self.viewModel.sortByName = true
            self.viewModel.sortClients = true
        }, handlerSecondAction: { (_) in
            self.viewModel.sortByName = false
            self.viewModel.sortClients = true
        }, handlerActionCancel: { (_) in
            self.viewModel.sortClients = false
        }, vc: self)
    }
    
    //MARK:: -- METHODS --
    
    func setScreen() {
        let nib = UINib(nibName: "ClientCell", bundle: nil)
        clientsTableView.register(nib, forCellReuseIdentifier: "clientCell")
        viewModel.delegate = self
        viewModel.requestClientsList()
    }
    
    func showInvalidPhoneAlert() {
        let alert = UIAlertController(title: "Invalid Phone", message: "The phone number you are trying to call is invalid", preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .default, handler: nil)
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK:: -- TABLE VIEW --
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.clientsToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clientCell", for: indexPath) as! ClientCell
        cell.delegate = self
        cell.update(viewData: ClientCellData(clientItem: viewModel.clientsToShow[indexPath.row]))
        return cell
    }
    
}

//MARK:: -- EXTENSIONS --

extension ClientListVC: ClientListViewModelDelegate {
    func onLoading() {
        clientsTableView.showActivityIndicator()
    }
    
    func onSuccess() {
        clientsTableView.hideActivityIndicator()
        clientsTableView.reloadData()
    }
    
    func onSortedAndFilteredClients() {
        clientsTableView.reloadData()
    }
}

extension ClientListVC: ClientCellDelegate {
    func onPhoneTapped(phoneNumber: String) {
        if phoneNumber.isValidPhone {
            guard let number = URL(string: "tel://" + phoneNumber) else { return }
            UIApplication.shared.open(number)
        } else {
            showInvalidPhoneAlert()
        }
    }
}

