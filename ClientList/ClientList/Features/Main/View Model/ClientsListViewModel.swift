//
//  ClientsListViewModel.swift
//  ClientList
//
//  Created by Alessandro Pace on 1/5/21.
//

import Foundation
import UIKit

protocol ClientListViewModelDelegate {
    func onLoading()
    func onSuccess()
    func onSortedAndFilteredClients()
}

class ClientListViewModel {
    
    var delegate: ClientListViewModelDelegate?
    var clientsToShow: [Client] = []
    
    //Filter and Sort Bools
    var filterClients = false {
        didSet {
            filterAndOrderClients()
        }
    }
    
    var sortClients = false {
        didSet {
            filterAndOrderClients()
        }
    }
    
    var filterByVisited = false
    var sortByName = false
    
    lazy var clientsList: [Client] = {
        if let jsonPath = Bundle.main.path(forResource: "clients", ofType: "json"),
           let data = NSData(contentsOfFile: jsonPath) {
            guard let list = try? JSONDecoder().decode([Client].self, from: data as Data) else {
                return []
            }
            return list
        }
        return []
    }()
    
    func requestClientsList() {
        delegate?.onLoading()
        clientsToShow = self.clientsList
        delegate?.onSuccess()
    }
    
    func showOptionSheet(firstOption: String, secondOption: String, handlerFirstAction: ((UIAlertAction) -> Void)?, handlerSecondAction: ((UIAlertAction) -> Void)?, handlerActionCancel: ((UIAlertAction) -> Void)? = nil, vc: UIViewController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: firstOption, style: .default, handler: handlerFirstAction))
        alert.addAction(UIAlertAction(title: secondOption, style: .default, handler: handlerSecondAction))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: handlerActionCancel))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func filterAndOrderClients() {
        switch true {
        case filterClients &&  sortClients:
            filterClientListByVisitedField(clientsToFilter: clientsList)
            sortClients(clientsToSort: clientsToShow)
        case filterClients:
            filterClientListByVisitedField(clientsToFilter: clientsList)
        case sortClients:
            sortClients(clientsToSort: clientsList)
        default:
            clientsToShow = clientsList
        }
        
        delegate?.onSortedAndFilteredClients()
    }
    
    func filterClientListByVisitedField(clientsToFilter: [Client]) {
        clientsToShow = clientsToFilter.filter { (item: Client) -> Bool in
            if filterByVisited {
                return item.visited == true
            } else {
                return item.visited == false
            }
        }
    }
    
    func sortClients(clientsToSort: [Client]) {
        if sortByName {
            clientsToShow.sort(by: { $0.name!.compare($1.name!) == .orderedAscending })
        } else {
            clientsToShow.sort(by: { $0.code!.compare($1.code!) == .orderedAscending })
        }
        
    }
    
}
