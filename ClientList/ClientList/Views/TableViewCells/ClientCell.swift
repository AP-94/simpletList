//
//  ClientCell.swift
//  ClientList
//
//  Created by Alessandro Pace on 1/5/21.
//

import UIKit

struct ClientCellData {
    var clientItem: Client?
}

protocol ClientCellDelegate {
    func onPhoneTapped(phoneNumber: String)
}


class ClientCell: UITableViewCell {
    
    //MARK:: -- OUTLETS --
    @IBOutlet weak var clientCodeLabel: UILabel!
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var clientEmailLabel: UILabel!
    @IBOutlet weak var clientVisitedLabel: UILabel!
    @IBOutlet weak var clientPhoneNumberButton: UIButton!

    //MARK:: -- VARS --
    var client: Client?
    var delegate: ClientCellDelegate?
    
    //MARK:: -- IBACTIONS --
    
    @IBAction func phoneNumberTapped(_ sender: Any) {
        if let clientPhone = client?.phoneNumber {
            delegate?.onPhoneTapped(phoneNumber: clientPhone)
        }
    }
    
    //MARK:: -- METHODS --
    
    func update(viewData: ClientCellData) {
        self.client = viewData.clientItem
        fillCell()
    }
    
    func fillCell() {
        guard let cellClient = client else {
            return
        }
        
        clientCodeLabel.text = cellClient.code
        clientNameLabel.text = cellClient.name
        clientEmailLabel.text = cellClient.email
        
        clientPhoneNumberButton.setTitle(cellClient.phoneNumber, for: .normal)
        
        if let visited = client?.visited {
            setVisitedLabel(to: visited)
        }
        
    }
    
    func setVisitedLabel(to visited: Bool) {
        clientVisitedLabel.text = visited ? "Visited" : "Not visited"
        clientVisitedLabel.textColor = visited ? .green : .red
    }
    
}
