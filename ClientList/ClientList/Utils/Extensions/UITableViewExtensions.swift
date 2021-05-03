//
//  UITableViewExtensions.swift
//  ClientList
//
//  Created by Alessandro Pace on 1/5/21.
//

import Foundation
import UIKit

extension UITableView {
    func showActivityIndicator() {
        DispatchQueue.main.async {
            let activityView = UIActivityIndicatorView(style: .medium)
            self.backgroundView = activityView
            activityView.startAnimating()
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.backgroundView = nil
        }
    }
}
