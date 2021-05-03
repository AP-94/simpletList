//
//  StringExtensions.swift
//  ClientList
//
//  Created by Alessandro Pace on 1/5/21.
//

import Foundation
import UIKit

extension String {
    var isValidPhone: Bool {
        let phoneRegEx = "(6|7)[ -]*([0-9][ -]*){8}"
        return NSPredicate(format:"SELF MATCHES %@", phoneRegEx).evaluate(with: self)
    }
}
